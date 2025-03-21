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

use finfo;
use NukeViet\Site;

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

/**
 * @author Phan Tan Dung
 */
class Mimes
{
    /**
     * Lấy mime của tập tin tải lên
     *
     * @param string $path
     * @return string
     */
    public static function get(string $path)
    {
        $mime = '';
        !$mime && $mime = self::getFinfo($path);
        !$mime && $mime = self::getExec($path);
        !$mime && $mime = self::getMimeContentType($path);

        return $mime;
    }

    /**
     * Lấy từ hàm mime_content_type
     *
     * @param string $path
     * @return string|array|NULL
     */
    public static function getMimeContentType(string $path)
    {
        $mime = '';

        if (Site::function_exists('mime_content_type')) {
            $mime = mime_content_type($path);
            $mime = preg_replace('/^([\.\-\w]+)\/([\.\-\w]+)(.*)$/i', '$1/$2', trim($mime));
        }

        return $mime;
    }

    /**
     * Lấy từ exec trong linux
     *
     * @param string $path
     * @return string|array|NULL
     */
    public static function getExec(string $path)
    {
        $mime = '';

        if (substr(PHP_OS, 0, 3) != 'WIN') {
            if (Site::function_exists('system')) {
                ob_start();
                system('file -i -b ' . escapeshellarg($path));
                $m = ob_get_clean();
                $m = trim($m);
                if (!empty($m)) {
                    $mime = preg_replace('/^([\.\-\w]+)\/([\.\-\w]+)(.*)$/i', '$1/$2', $m);
                }
            } elseif (Site::function_exists('exec')) {
                $m = @exec('file -bi ' . escapeshellarg($path));
                $m = trim($m);
                if (!empty($m)) {
                    $mime = preg_replace('/^([\.\-\w]+)\/([\.\-\w]+)(.*)$/i', '$1/$2', $m);
                }
            }
        }

        return $mime;
    }

    /**
     * Lấy từ finfo_open
     *
     * @param string $path
     * @return string|array|NULL
     */
    public static function getFinfo(string $path)
    {
        $mime = '';
        if (Site::function_exists('finfo_open')) {
            $finfo = finfo_open(FILEINFO_MIME);
            if (!empty($finfo)) {
                $mime = finfo_file($finfo, $path);
                finfo_close($finfo);
                $mime = preg_replace('/^([\.\-\w]+)\/([\.\-\w]+)(.*)$/i', '$1/$2', trim($mime));
            }
        }

        if (empty($mime) or $mime == 'application/octet-stream') {
            if (Site::class_exists('finfo')) {
                $finfo = new finfo(FILEINFO_MIME);
                if ($finfo) {
                    $mime = $finfo->file($path);
                    $mime = preg_replace('/^([\.\-\w]+)\/([\.\-\w]+)(.*)$/i', '$1/$2', trim($mime));
                }
            }
        }

        return $mime;
    }
}
