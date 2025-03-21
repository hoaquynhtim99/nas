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
class FileTypes
{
    const LISTS = [
        'all', 'document', 'image', 'movie', 'music'
    ];

    const TYPE_ALL = 'all';
    const TYPE_DOCUMENT = 'document';
    const TYPE_IMAGE = 'image';
    const TYPE_MOVIE = 'movie';
    const TYPE_MUSIC = 'music';

    const EXT_DEFINE = [
        'pdf' => 'pdf',

        'jpg' => 'image',
        'jpeg' => 'image',
        'png' => 'image',
        'gif' => 'image',
        'bmp' => 'image',
        'tif' => 'image',
        'tiff' => 'image',
        'ico' => 'image',
        'svg' => 'image',
        'webp' => 'image',
        'psd' => 'image',
        'ai' => 'image',

        'mp4' => 'video',
        'avi' => 'video',
        'mov' => 'video',
        'mpg' => 'video',
        'mpeg' => 'video',
        'wmv' => 'video',
        '3gp' => 'video',
        'flv' => 'video',
        'webm' => 'video',

        'zip' => 'zip',
        'gz' => 'zip',
        'rar' => 'zip',
        'tar' => 'zip',
        'bz2' => 'zip',
        '7z' => 'zip',
        'iso' => 'zip',

        'txt' => 'text',
        'xml' => 'text',
        'xsl' => 'text',

        'htm' => 'code',
        'html' => 'code',
        'htmls' => 'code',
        'css' => 'code',
        'js' => 'code',
        'exe' => 'code',
        'pls' => 'code',
        'm3u' => 'code',

        'aif' => 'audio',
        'aiff' => 'audio',
        'adp' => 'audio',
        'au' => 'audio',
        'midi' => 'audio',
        'mid' => 'audio',
        'kar' => 'audio',
        'mp4a' => 'audio',
        'mp3' => 'audio',
        'wav' => 'audio',

        'doc' => 'word',
        'docx' => 'word',
        'docm' => 'word',
        'dotm' => 'word',
        'dotx' => 'word',
        'rtf' => 'word',
        'odt' => 'word',

        'ppt' => 'powerpoint',
        'pptm' => 'powerpoint',
        'pptx' => 'powerpoint',
        'pps' => 'powerpoint',
        'ppsm' => 'powerpoint',
        'ppsx' => 'powerpoint',
        'potm' => 'powerpoint',
        'potx' => 'powerpoint',
        'ppam' => 'powerpoint',

        'xls' => 'excel',
        'xlsb' => 'excel',
        'xlsm' => 'excel',
        'xlsx' => 'excel',
    ];

    /**
     * @param string $ext
     * @return string
     */
    public static function typeFromExt(?string $ext)
    {
        return self::EXT_DEFINE[$ext] ?? 'file';
    }

    /**
     * @param string $type
     * @return string[]
     */
    public static function extsFromType(?string $type)
    {
        $defines = [
            self::TYPE_ALL => ['pdf', 'image', 'video', 'zip', 'text', 'code', 'audio', 'word'],
            self::TYPE_DOCUMENT => ['pdf', 'word'],
            self::TYPE_IMAGE => ['image'],
            self::TYPE_MOVIE => ['video'],
            self::TYPE_MUSIC => ['audio'],
        ];

        $exts = [];
        foreach (self::EXT_DEFINE as $ext_i => $type_i) {
            if (in_array($type_i, $defines[$type])) {
                $exts[] = $ext_i;
            }
        }

        return $exts;
    }
}
