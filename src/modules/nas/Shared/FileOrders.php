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

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

/**
 * @author Phan Tan Dung
 */
class FileOrders
{
    const LISTS = [
        'title_asc', 'title_desc',
        'add_asc', 'add_desc',
        'edit_asc', 'edit_desc',
        'ext_asc', 'ext_desc',
    ];

    const ORDER_TITLE_ASC = 'title_asc';
    const ORDER_TITLE_DESC = 'title_desc';
    const ORDER_ADD_ASC = 'add_asc';
    const ORDER_ADD_DESC = 'add_desc';
    const ORDER_EDIT_ASC = 'edit_asc';
    const ORDER_EDIT_DESC = 'edit_desc';
    const ORDER_EXT_ASC = 'ext_asc';
    const ORDER_EXT_DESC = 'ext_desc';

    /**
     * Lấy trường, kiểu sắp xếp
     *
     * @param string $sort
     * @throws \Exception
     * @return string[]|mixed[]
     */
    public static function getOrder(string $sort)
    {
        if (!in_array($sort, self::LISTS, true)) {
            throw new \Exception('Sort method not exit!!!');
        }

        $array = [
            'title' => 'title',
            'add' => 'add_time',
            'edit' => 'edit_time',
            'ext' => 'node_ext'
        ];
        $sort = explode('_', $sort);
        return [$array[$sort[0]], $sort[1]];
    }
}
