<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2023 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

namespace NukeViet\Module\nas\Shared;

use Google\Service\Drive;

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

/**
 * @author Phan Tấn Dũng <writeblabla@gmail.com>
 */
class Nodes
{
    const TYPE_FOLDER = 1;
    const TYPE_FILE = 0;

    /**
     * Xóa hẳn tệp, thư mục khỏi ổ đĩa và CSDL.
     * Phương thức này không kiểm tra quyền sở hữu, vui lòng đảm bảo an toàn trước khi gọi nó
     *
     * @param int $id
     * @param int $is_tmp
     * @return bool|int
     */
    public static function remove(int $id, int $is_tmp = 0)
    {
        global $db, $module_data;

        // Lấy node đang ở trong thùng rác
        $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE id=" . $id . "
        AND (trash>0 OR is_tmp>0) AND trash_parent=0";
        $node = $db->query($sql)->fetch();
        if (empty($node)) {
            return false;
        }

        // Lấy username của node này
        $sql = "SELECT username FROM " . NV_USERS_GLOBALTABLE . " WHERE userid=" . $node['userid'];
        $username = $db->query($sql)->fetchColumn() ?: '';
        if (!preg_match('/^[a-zA-Z0-9]+$/i', $username)) {
            return false;
        }
        $username = strtolower($username);

        // Xóa trên ổ đĩa
        $path = NAS_DIR . '/' . $username . '/' . $node['path'];
        if (file_exists($path) and !self::deleteFolder($path)) {
            return false;
        }
        // Xóa thumb
        $path_thumb = NV_ROOTDIR . '/' . NV_ASSETS_DIR . '/nas-data/' . $username . '/' . $node['path'];
        self::deleteFolder($path_thumb);

        // Xóa cover nếu có
        $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes_refs WHERE node_id=" . $id;
        $node_refs = $db->query($sql)->fetch();
        if (!empty($node_refs) and !empty($node_refs['image_cover'])) {
            self::deleteFolder(NV_ROOTDIR . '/' . NV_ASSETS_DIR . '/nas-cover/' . $node_refs['image_cover']);
        }

        /*
         * Nếu là thư mục, xóa các tệp/thư mục con
         * Chỉ xóa khỏi CSDL không phải xóa trên ổ đĩa bởi thao tác bên trên đã xóa cả thư mục trên ổ đĩa
         */
        if ($node['node_type'] == self::TYPE_FOLDER) {
            $where = [];
            $where[] = "parentid=" . $node['id'];
            if (!empty($node['subcatids'])) {
                $where[] = "parentid IN(" . $node['subcatids'] . ")";
            }

            $sql = "DELETE FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes_refs WHERE node_id IN(
                SELECT id FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE " . implode(' OR ', $where) . "
            )";
            $db->query($sql);

            $sql = "DELETE FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE " . implode(' OR ', $where);
            $db->query($sql);
        }

        // Xóa chính nó và refs
        $sql = "DELETE FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE id=" . $id;
        $db->query($sql);

        $sql = "DELETE FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes_refs WHERE node_id=" . $id;
        $db->query($sql);

        // Cập nhật dung lượng của user
        if (empty($is_tmp)) {
            try {
                $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_users SET
                    quota_current = IF(quota_current >= " . $node['node_size'] . ", (quota_current-" . $node['node_size'] . "), 0)
                WHERE userid=" . $node['userid'];
                $db->query($sql);
            } catch (\Throwable $e) {
                trigger_error(print_r($e, true));
            }

            // Cập nhật giảm dung lượng thư mục cha
            $where = [];
            if (!empty($node['parentid'])) {
                // Cấp cha kề trước nó
                $where[] = "id=" . $node['parentid'];
            }
            if (!empty($node['parentids'])) {
                // Nếu là thư mục có thư mục cha
                $where[] = "id IN(" . $node['parentids'] . ")";
            } elseif (!empty($node['parentid'])) {
                // Lấy thư mục cha của nó nếu có để tính ra bên ngoài
                $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE id=" . $node['parentid'];
                $parent_node = $db->query($sql)->fetch();
                if (!empty($parent_node) and !empty($parent_node['parentids'])) {
                    $where[] = "id IN(" . $parent_node['parentids'] . ")";
                }
            }
            if (!empty($where)) {
                try {
                    $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
                        node_size = IF(node_size >= " . $node['node_size'] . ", (node_size-" . $node['node_size'] . "), 0)
                    WHERE " . implode(' OR ', $where);
                    $db->query($sql);
                } catch (\Throwable $e) {
                    trigger_error(print_r($e, true));
                }
            }
        }

        // Tính toán lại cây thư mục
        if ($node['node_type'] == self::TYPE_FOLDER) {
            self::syncFoldersOrder($node['userid']);
        }

        // Cuối cùng nếu nó đã đồng bộ thì xóa trên Google Drive
        // Điều kiện empty($node['sync_appid']) cho thấy nó không phải là thư mục cha được thiết lập đồng bộ
        // Chính nó bị xóa đi thì thư mục đồng bộ bên Google Drive vẫn giữ lại
        if (empty($node['sync_appid']) and !empty($node['sync_folderid'])) {
            $sync_app_id = 0;

            // Lấy thư mục cha của nó
            $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE id=" . $node['parentid'];
            $parent_node = $db->query($sql)->fetch();
            if (!empty($parent_node) and !empty($parent_node['sync_appid'])) {
                // Nếu thư mục cha của nó chính là thư mục đồng bộ thì dừng ở đây
                $sync_app_id = $parent_node['sync_appid'];
            }
            if (empty($sync_app_id) and !empty($parent_node) and !empty($parent_node['parentids'])) {
                // Thư mục cha của nó chưa là thư mục đồng bộ thì tìm ra bên ngoài để lấy thư mục đồng bộ
                $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes WHERE
                id IN(" . $parent_node['parentids'] . ") AND sync_appid>0 LIMIT 1";
                $parent_node = $db->query($sql)->fetch();
                if (!empty($parent_node)) {
                    $sync_app_id = $parent_node['sync_appid'];
                }
            }
            $sync_app = [];
            if (!empty($sync_app_id)) {
                $sql = "SELECT * FROM " . NV_PREFIXLANG . "_" . $module_data . "_api_credentials WHERE id=" . $sync_app_id;
                $sync_app = $db->query($sql)->fetch();
            }
            if (!empty($sync_app) and !empty($sync_app['is_setup']) and empty($sync_app['is_error'])) {
                $client = GoogleDrives::getClient($sync_app);
                if (!is_string($client)) {
                    try {
                        $service = new Drive($client);
                        $service->files->delete($node['sync_folderid']);
                    } catch (\Throwable $e) {
                        trigger_error(print_r($e, true));
                        Notices::save($node['userid'], 'DEL_NODE', 'Error when delete synced file/folder', $node['title'] . ' can not delete on Google Drive: ' . $e->getMessage());
                    }
                }
            }
        }

        return true;
    }

    /**
     * @param string $folderPath
     * @return boolean
     */
    public static function deleteFolder($folderPath)
    {
        if (is_file($folderPath)) {
            return unlink($folderPath);
        }
        if (!is_dir($folderPath)) {
            return false;
        }

        $items = array_diff(scandir($folderPath), [
            '.',
            '..'
        ]);

        foreach ($items as $item) {
            $itemPath = $folderPath . DIRECTORY_SEPARATOR . $item;

            if (is_dir($itemPath)) {
                self::deleteFolder($itemPath);
            } else {
                unlink($itemPath);
            }
        }

        return rmdir($folderPath);
    }

    /**
     * Hàm chính tính toán cập nhật cây thư mục của thành viên
     */
    public static function syncFoldersOrder(int $userid = 0)
    {
        global $db, $module_data;

        // Trong trường hợp không truyền userid thì là người đang thao tác trên module nas
        if (empty($userid)) {
            if (!defined('NV_IS_USER')) {
                throw new \Exception("Wrong use this method while not in system!!!");
            }
            global $user_info;
            $userid = $user_info['userid'];
        }

        // Cập nhật weight, sort, subcatid, numsubcat
        [$sort_last, $data, $data_parents] = self::syncFoldersOrder__1($userid);
        unset($data[0]);

        // Cập nhật subcatids
        foreach ($data as $folder_id => $subids) {
            $subids = self::syncFoldersOrder__2($folder_id, $data);
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
                subcatids=" . (empty($subids) ? "''" : $db->quote(implode(',', $subids))) . "
            WHERE id=" . $folder_id;
            $db->query($sql);
        }

        // Cập nhật parentids
        foreach ($data_parents as $folder_id => $parentid) {
            $parentids = self::syncFoldersOrder__3($folder_id, $data_parents);
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
                parentids=" . (empty($parentids) ? "''" : $db->quote(implode(',', $parentids))) . "
            WHERE id=" . $folder_id;
            $db->query($sql);
        }
    }

    /**
     * Hàm trung gian tính subcatids của cây thư mục thành viên
     *
     * @param int $folder_id
     * @param array $subids
     * @param array $stacks
     * @return array
     */
    public static function syncFoldersOrder__2(int $folder_id, array $subids, $stacks = [])
    {
        if (!isset($subids[$folder_id])) {
            return [];
        }
        foreach ($subids[$folder_id] as $fid) {
            $stacks[] = $fid;
            if (isset($subids[$fid])) {
                $stacks = self::syncFoldersOrder__2($fid, $subids, $stacks);
            }
        }

        return $stacks;
    }

    /**
     * Hàm trung gian tính parentids của cây thư mục thành viên
     *
     * @param int $folder_id
     * @param array $parentids
     * @param array $stacks
     * @return array
     */
    public static function syncFoldersOrder__3(int $folder_id, array $parentids, $stacks = [])
    {
        if (!isset($parentids[$folder_id])) {
            return [];
        }
        $parentid = $parentids[$folder_id];
        $stacks[] = $parentid;
        if (isset($parentids[$parentid])) {
            $stacks = self::syncFoldersOrder__3($parentid, $parentids, $stacks);
        }

        return $stacks;
    }

    /**
     * Hàm trung gian tính toán weight, sort, subcatid, numsubcat của cây thư mục thành viên
     *
     * @param number $userid
     * @param number $parentid
     * @param number $order
     * @param number $lev
     * @param array $subids
     * @param array $parentids
     * @return number[]|mixed[]
     */
    public static function syncFoldersOrder__1($userid, $parentid = 0, $order = 0, $lev = 0, $subids = [], $parentids = [])
    {
        global $db, $module_data;

        // Lấy thư mục con liền kề của nó hoặc là cấp cha đầu tiên
            $sql = "SELECT id, parentid FROM " . NV_PREFIXLANG . "_" . $module_data . "_nodes
        WHERE parentid=" . $parentid . " AND userid=" . $userid . " AND node_type=1 ORDER BY title ASC";
        $result = $db->query($sql);

        $array_cat_order = [];
        while ($row = $result->fetch()) {
            $array_cat_order[] = $row['id'];
        }
        $result->closeCursor();

        $weight = 0;
        if ($parentid > 0) {
            ++$lev;
        } else {
            $lev = 0;
        }

        // Xếp weight cấp này, gọi đệ quy để trả về cấp con, sort
        foreach ($array_cat_order as $id_i) {
            ++$order;
            ++$weight;
            $subids[$parentid][] = $id_i;
            if ($parentid > 0) {
                $parentids[$id_i] = $parentid;
            }

            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET
                weight=" . $weight . ", sort=" . $order . ", lev=" . $lev . ", subcatids='', parentids=''
            WHERE id=" . intval($id_i);
            $db->query($sql);

            [$order, $subids, $parentids] = self::syncFoldersOrder__1($userid, $id_i, $order, $lev, $subids, $parentids);
        }

        // Cập nhật cho cấp cha của nó
        $numsubcat = $weight;
        if ($parentid > 0) {
            $sql = "UPDATE " . NV_PREFIXLANG . "_" . $module_data . "_nodes SET numsubcat=" . $numsubcat;
            if ($numsubcat == 0) {
                $sql .= ", subcatid=''";
            } else {
                $sql .= ", subcatid='" . implode(',', $array_cat_order) . "'";
            }
            $sql .= " WHERE id=" . intval($parentid);
            $db->query($sql);
        }

        return [$order, $subids, $parentids];
    }
}
