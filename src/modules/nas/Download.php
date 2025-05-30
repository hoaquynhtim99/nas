<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2023 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

namespace NukeViet\Module\nas;

use finfo;
use NukeViet\Site;

if (!defined('NV_MIME_INI_FILE')) {
    define('NV_MIME_INI_FILE', NV_ROOTDIR . '/includes/ini/mime.ini');
}

/**
 * NukeViet\Files\Download
 *
 * @package NukeViet\Files
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2021 VINADES.,JSC. All rights reserved
 * @version 4.5.00
 * @access public
 */
class Download
{
    private $properties = [
        'path' => '',
        'name' => '',
        'extension' => '',
        'type' => '',
        'size' => '',
        'mtime' => 0,
        'resume' => '',
        'max_speed' => ''
    ];
    private $magic_path;

    /**
     * Lưu ý: Class này download bất kì tệp tin nào được truyền vào.
     * Cần kiểm tra bảo mật trước khi dùng nó
     *
     * @param string $path
     * @param string $name
     * @param bool   $resume
     * @param int    $max_speed
     * @param mixed  $magic_path
     */
    public function __construct($path, $name = '', $resume = true, $max_speed = 0, $magic_path = '')
    {
        $extension = $this->getextension($path);
        $this->properties = [
            'path' => $path,
            'name' => ($name == '') ? substr(strrchr('/' . $path, '/'), 1) : $name,
            'extension' => $extension,
            'type' => '',
            'size' => (int) (sprintf('%u', filesize($path))),
            'mtime' => ($mtime = filemtime($path)) > 0 ? $mtime : time(),
            'resume' => $resume,
            'max_speed' => $max_speed
        ];
        $this->properties['type'] = $this->my_mime_content_type($path);
        $this->magic_path = $magic_path;
    }

    /**
     * @param string $filename
     * @return string
     */
    private function getextension($filename)
    {
        if (!str_contains($filename, '.')) {
            return '';
        }
        $filename = basename(strtolower($filename));
        $filename = explode('.', $filename);

        return array_pop($filename);
    }

    /**
     * my_mime_content_type()
     *
     * @param string $path
     * @return string
     */
    private function my_mime_content_type($path)
    {
        $mime = '';

        if (Site::function_exists('finfo_open')) {
            if (empty($this->magic_path)) {
                $finfo = finfo_open(FILEINFO_MIME);
            } elseif ($this->magic_path != 'auto') {
                $finfo = finfo_open(FILEINFO_MIME, $this->magic_path);
            } else {
                if (($magic = getenv('MAGIC')) !== false) {
                    $finfo = finfo_open(FILEINFO_MIME, $magic);
                } else {
                    if (substr(PHP_OS, 0, 3) == 'WIN') {
                        $path = realpath(ini_get('extension_dir') . '/../') . 'extras/magic';
                        $finfo = finfo_open(FILEINFO_MIME, $path);
                    } else {
                        $finfo = finfo_open(FILEINFO_MIME, '/usr/share/file/magic');
                    }
                }
            }

            if ($finfo !== false) {
                $mime = finfo_file($finfo, realpath($path));
                finfo_close($finfo);
                $mime = preg_replace('/^([\.\-\w]+)\/([\.\-\w]+)(.*)$/i', '$1/$2', trim($mime));
            }
        }

        if (empty($mime) or $mime == 'application/octet-stream') {
            if (Site::class_exists('finfo')) {
                $finfo = new finfo(FILEINFO_MIME);
                if ($finfo) {
                    $mime = $finfo->file(realpath($path));
                    $mime = preg_replace('/^([\.\-\w]+)\/([\.\-\w]+)(.*)$/i', '$1/$2', trim($mime));
                }
            }
        }

        if (empty($mime) or $mime == 'application/octet-stream') {
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
        }

        if (empty($mime) or $mime == 'application/octet-stream') {
            if (Site::function_exists('mime_content_type')) {
                $mime = mime_content_type($path);
                $mime = preg_replace('/^([\.\-\w]+)\/([\.\-\w]+)(.*)$/i', '$1/$2', trim($mime));
            }
        }

        if (empty($mime) or $mime == 'application/octet-stream') {
            $img_exts = ['png', 'gif', 'jpg', 'bmp', 'tiff', 'swf', 'psd'];
            if (in_array($this->properties['extension'], $img_exts, true)) {
                if (($img_info = @getimagesize($path)) !== false) {
                    if (array_key_exists('mime', $img_info) and !empty($img_info['mime'])) {
                        $mime = trim($img_info['mime']);
                        $mime = preg_replace('/^([\.\-\w]+)\/([\.\-\w]+)(.*)$/i', '$1/$2', $mime);
                    }

                    if (empty($mime) and isset($img_info[2])) {
                        $mime = image_type_to_mime_type($img_info[2]);
                    }
                }
            }
        }

        if (empty($mime) or $mime == 'application/octet-stream') {
            $mime_types = nv_parse_ini_file(NV_MIME_INI_FILE);

            if (array_key_exists($this->properties['extension'], $mime_types)) {
                if (is_string($mime_types[$this->properties['extension']])) {
                    return $mime_types[$this->properties['extension']];
                }
                $mime = $mime_types[$this->properties['extension']][0];
            }
        }

        if (preg_match('/^application\/(?:x-)?zip(?:-compressed)?$/is', $mime)) {
            if ($this->properties['extension'] == 'docx') {
                $mime = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
            } elseif ($this->properties['extension'] == 'dotx') {
                $mime = 'application/vnd.openxmlformats-officedocument.wordprocessingml.template';
            } elseif ($this->properties['extension'] == 'potx') {
                $mime = 'application/vnd.openxmlformats-officedocument.presentationml.template';
            } elseif ($this->properties['extension'] == 'ppsx') {
                $mime = 'application/vnd.openxmlformats-officedocument.presentationml.slideshow';
            } elseif ($this->properties['extension'] == 'pptx') {
                $mime = 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
            } elseif ($this->properties['extension'] == 'xlsx') {
                $mime = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
            } elseif ($this->properties['extension'] == 'xltx') {
                $mime = 'application/vnd.openxmlformats-officedocument.spreadsheetml.template';
            } elseif ($this->properties['extension'] == 'docm') {
                $mime = 'application/vnd.ms-word.document.macroEnabled.12';
            } elseif ($this->properties['extension'] == 'dotm') {
                $mime = 'application/vnd.ms-word.template.macroEnabled.12';
            } elseif ($this->properties['extension'] == 'potm') {
                $mime = 'application/vnd.ms-powerpoint.template.macroEnabled.12';
            } elseif ($this->properties['extension'] == 'ppam') {
                $mime = 'application/vnd.ms-powerpoint.addin.macroEnabled.12';
            } elseif ($this->properties['extension'] == 'ppsm') {
                $mime = 'application/vnd.ms-powerpoint.slideshow.macroEnabled.12';
            } elseif ($this->properties['extension'] == 'pptm') {
                $mime = 'application/vnd.ms-powerpoint.presentation.macroEnabled.12';
            } elseif ($this->properties['extension'] == 'xlam') {
                $mime = 'application/vnd.ms-excel.addin.macroEnabled.12';
            } elseif ($this->properties['extension'] == 'xlsb') {
                $mime = 'application/vnd.ms-excel.sheet.binary.macroEnabled.12';
            } elseif ($this->properties['extension'] == 'xlsm') {
                $mime = 'application/vnd.ms-excel.sheet.macroEnabled.12';
            } elseif ($this->properties['extension'] == 'xltm') {
                $mime = 'application/vnd.ms-excel.template.macroEnabled.12';
            }
        }

        return !empty($mime) ? $mime : 'application/force-download';
    }

    /**
     * get_property()
     *
     * @param string $property
     * @return string|null
     */
    public function get_property($property)
    {
        if (array_key_exists($property, $this->properties)) {
            return $this->properties[$property];
        }

        return null;
    }

    /**
     * set_property()
     *
     * @param string $property
     * @param string $value
     * @return bool
     */
    public function set_property($property, $value)
    {
        if (array_key_exists($property, $this->properties)) {
            $this->properties[$property] = $value;

            return true;
        }

        return false;
    }

    /**
     * download_file()
     *
     * @return never
     * @param mixed $attachment
     */
    public function download_file($attachment = 1)
    {
        if (!$this->properties['path']) {
            exit('Nothing to download!');
        }

        $seek_start = 0;
        $seek_end = -1;
        $data_section = false;

        if (($http_range = Site::getEnv('HTTP_RANGE')) != '') {
            $seek_range = substr($http_range, 6);

            $range = explode('-', $seek_range);

            if (!empty($range[0])) {
                $seek_start = (int) ($range[0]);
            }

            if (isset($range[1]) and !empty($range[1])) {
                $seek_end = (int) ($range[1]);
            }

            if (!$this->properties['resume']) {
                $seek_start = 0;
            } else {
                $data_section = true;
            }
        }

        if (@ob_get_length()) {
            @ob_end_clean();
        }
        $old_status = ignore_user_abort(true);

        if (Site::function_exists('set_time_limit')) {
            set_time_limit(0);
        }

        if ($seek_start > ($this->properties['size'] - 1)) {
            $seek_start = 0;
        }

        $res = fopen($this->properties['path'], 'rb');

        if (!$res) {
            exit('File error');
        }

        if ($seek_start) {
            fseek($res, $seek_start);
        }
        if ($seek_end < $seek_start) {
            $seek_end = $this->properties['size'] - 1;
        }

        header('Pragma: public');
        header('Expires: 0');
        header('Cache-Control:');
        header('Cache-Control: public');
        header('Content-Description: File Transfer');
        header('Content-Type: ' . $this->properties['type']);
        if ($attachment) {
            if (strstr(Site::getEnv('HTTP_USER_AGENT'), 'MSIE') != false) {
                header('Content-Disposition: attachment; filename="' . urlencode($this->properties['name']) . '";');
            } else {
                header('Content-Disposition: attachment; filename="' . $this->properties['name'] . '";');
            }
        }
        header('Last-Modified: ' . date('D, d M Y H:i:s \G\M\T', $this->properties['mtime']));

        if ($data_section and $this->properties['resume']) {
            http_response_code(206);
            header('Accept-Ranges: bytes');
            header('Content-Range: bytes ' . $seek_start . '-' . $seek_end . '/' . $this->properties['size']);
            header('Content-Length: ' . ($seek_end - $seek_start + 1));
        } else {
            header('Content-Length: ' . $this->properties['size']);
        }

        if (Site::function_exists('usleep') and ($speed = $this->properties['max_speed']) > 0) {
            $sleep_time = (8 / $speed) * 1e6;
        } else {
            $sleep_time = 0;
        }

        while (!(connection_aborted() or connection_status() == 1) and !feof($res)) {
            echo fread($res, 1024 * 8);
            flush();
            if ($sleep_time > 0) {
                usleep($sleep_time);
            }
        }
        fclose($res);

        ignore_user_abort($old_status);
        if (Site::function_exists('set_time_limit')) {
            set_time_limit(ini_get('max_execution_time'));
        }
        exit(0);
    }
}
