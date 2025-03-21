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
class Drives
{
    const LIST_DRIVE = [
        'shared', 'document', 'media', 'history', 'bookmark', 'trash'
    ];

    const DRIVE_FILE = 'drive';
    const DRIVE_SHARED = 'shared';
    const DRIVE_DOCUMENT = 'document';
    const DRIVE_MEDIA = 'media';
    const DRIVE_HISTORY = 'history';
    const DRIVE_BOOKMARK = 'bookmark';
    const DRIVE_TRASH = 'trash';
}
