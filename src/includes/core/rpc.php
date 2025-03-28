<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_MAINFILE')) {
    exit('Stop!!!');
}

/**
 * nv_getRPC()
 *
 * @param string $url
 * @param mixed  $data
 * @return array
 */
function nv_getRPC($url, $data)
{
    global $nv_Lang, $sys_info;

    $userAgents = ['Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1) Gecko/20090624 Firefox/3.5 (.NET CLR 3.5.30729)', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)', 'Mozilla/4.8 [en] (Windows NT 6.0; U)', 'Opera/9.25 (Windows NT 6.0; U; en)'];

    mt_srand(microtime(true) * 1000000);
    $rand = array_rand($userAgents);
    $agent = $userAgents[$rand];

    $url_info = parse_url($url);
    $url_info['port'] = isset($url_info['port']) ? (int) ($url_info['port']) : 80;
    if (isset($url_info['path'])) {
        if (substr($url_info['path'], 0, 1) != '/') {
            $url_info['path'] = '/' . $url_info['path'];
        }
    } else {
        $url_info['path'] = '/';
    }
    $url_info['query'] = (isset($url_info['query']) and !empty($url_info['query'])) ? '?' . $url_info['query'] : '';

    $proxy = [];
    if (file_exists(NV_ROOTDIR . '/' . NV_DATADIR . '/proxies.php')) {
        include NV_ROOTDIR . '/' . NV_DATADIR . '/proxies.php';
        if (!empty($proxy)) {
            $proxy = $proxy[random_int(0, count($proxy) - 1)];
        }
    }
    if (nv_function_exists('fsockopen')) {
        if (!empty($proxy)) {
            $fp = @fsockopen($proxy[1], $proxy[2], $errno, $errstr, 10);
            if ($fp) {
                $http_request = 'POST ' . $url . " HTTP/1.0\r\n";
                $http_request .= 'Host: ' . $url_info['host'] . ':' . $url_info['port'] . "\r\n";
                $http_request .= "Content-Type: text/xml\r\n";
                $http_request .= 'Content-Length: ' . strlen($data) . "\r\n";
                $http_request .= 'User-Agent: ' . $agent . "\r\n";

                if (isset($proxy[3], $proxy[4]) and !empty($proxy[3]) and !empty($proxy[4])) {
                    $http_request .= 'Proxy-Authorization: Basic ' . base64_encode($proxy[3] . ':' . $proxy[4]) . "\r\n";
                }
                $http_request .= "\r\n";
                $response = '';
                fwrite($fp, $http_request);
                fwrite($fp, $data);
                while (!feof($fp)) {
                    $response .= fgets($fp, 64000);
                }
                fclose($fp);
                [$header, $result] = preg_split("/\r?\n\r?\n/", $response, 2);

                unset($matches);
                preg_match("/^HTTP\/[0-9\.]+\s+(\d+)\s+/", $header, $matches);
                if (!isset($matches[1]) or (isset($matches[1]) and $matches[1] != 200)) {
                    if (!empty($errstr)) {
                        return [2, trim(strip_tags($errstr . '(' . $errno . ')'))];
                    }

                    return [3, $nv_Lang->getModule('rpc_error_unknown')];
                }

                unset($matches1, $matches2);
                if (preg_match("/\<member\>[\s\n\t\r]*\<name\>[\s\n\t\r]*flerror[\s\n\t\r]*\<\/name\>[\s\n\t\r]*\<value\>[\s\n\t\r]*(\<boolean\>)?[\s\n\t\r]*([0|1]{1})[\s\n\t\r]*(\<\/boolean\>)?[\s\n\t\r]*\<\/value\>[\s\n\t\r]*\<\/member\>/is", $result, $matches1) and preg_match("/\<member\>[\s\n\t\r]*\<name\>[\s\n\t\r]*message[\s\n\t\r]*\<\/name\>[\s\n\t\r]*\<value\>[\s\n\t\r]*(\<string\>)?[\s\n\t\r]*([^\<]*)[\s\n\t\r]*(\<\/string\>)?[\s\n\t\r]*\<\/value\>[\s\n\t\r]*\<\/member\>/is", $result, $matches2)) {
                    return [(int) $matches1[2], (string) $matches2[2]];
                }

                return [3, $nv_Lang->getModule('rpc_error_unknown')];
            }
        }

        $fp = @fsockopen($url_info['host'], $url_info['port'], $errno, $errstr, 10);
        if (!$fp) {
            return [3, $nv_Lang->getModule('rpc_error_unknown')];
        }

        $http_request = 'POST ' . $url_info['path'] . $url_info['query'] . " HTTP/1.0\r\n";
        $http_request .= 'Host: ' . $url_info['host'] . ':' . $url_info['port'] . "\r\n";
        $http_request .= "Content-Type: text/xml\r\n";
        $http_request .= 'Content-Length: ' . strlen($data) . "\r\n";
        $http_request .= 'User-Agent: ' . $agent . "\r\n\r\n";
        $response = '';
        fwrite($fp, $http_request);
        fwrite($fp, $data);
        while (!feof($fp)) {
            $response .= fgets($fp, 64000);
        }
        fclose($fp);
        [$header, $result] = preg_split("/\r?\n\r?\n/", $response, 2);

        unset($matches);
        preg_match("/^HTTP\/[0-9\.]+\s+(\d+)\s+/", $header, $matches);
        if (!isset($matches[1]) or (isset($matches[1]) and $matches[1] != 200)) {
            if (!empty($errstr)) {
                return [2, trim(strip_tags($errstr . '(' . $errno . ')'))];
            }

            return [3, $nv_Lang->getModule('rpc_error_unknown')];
        }

        unset($matches1, $matches2);
        if (preg_match("/\<member\>[\s\n\t\r]*\<name\>[\s\n\t\r]*flerror[\s\n\t\r]*\<\/name\>[\s\n\t\r]*\<value\>[\s\n\t\r]*(\<boolean\>)?[\s\n\t\r]*([0|1]{1})[\s\n\t\r]*(\<\/boolean\>)?[\s\n\t\r]*\<\/value\>[\s\n\t\r]*\<\/member\>/is", $result, $matches1) and preg_match("/\<member\>[\s\n\t\r]*\<name\>[\s\n\t\r]*message[\s\n\t\r]*\<\/name\>[\s\n\t\r]*\<value\>[\s\n\t\r]*(\<string\>)?[\s\n\t\r]*([^\<]*)[\s\n\t\r]*(\<\/string\>)?[\s\n\t\r]*\<\/value\>[\s\n\t\r]*\<\/member\>/is", $result, $matches2)) {
            return [(int) $matches1[2], (string) $matches2[2]];
        }

        return [3, $nv_Lang->getModule('rpc_error_unknown')];
    }

    if (!nv_function_exists('curl_init') or !nv_function_exists('curl_exec')) {
        return [3, $nv_Lang->getModule('rpc_error_unknown')];
    }

    $header = ['Content-Type:text/xml', 'Host:' . $url_info['host'] . ':' . $url_info['port'], 'User-Agent:' . $agent, 'Content-length: ' . strlen($data)];

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_USERAGENT, $agent);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $header);

    if (!empty($proxy)) {
        if ($proxy[0] == 'SOCKS4') {
            curl_setopt($ch, CURLOPT_PROXYTYPE, CURLPROXY_SOCKS4);
        } elseif ($proxy[0] == 'SOCKS5') {
            curl_setopt($ch, CURLOPT_PROXYTYPE, CURLPROXY_SOCKS5);
        } else {
            curl_setopt($ch, CURLOPT_PROXYTYPE, CURLPROXY_HTTP);
        }

        curl_setopt($ch, CURLOPT_PROXY, $proxy[1]);
        curl_setopt($ch, CURLOPT_PROXYPORT, $proxy[2]);

        if ($proxy[3] and $proxy[4]) {
            curl_setopt($ch, CURLOPT_PROXYUSERPWD, $proxy[3] . ':' . $proxy[4]);
        }
    }

    $result['XML'] = curl_exec($ch);
    $result['ERR'] = trim(curl_error($ch));
    curl_close($ch);

    unset($matches1, $matches2);
    if (preg_match("/\<member\>[\s\n\t\r]*\<name\>[\s\n\t\r]*flerror[\s\n\t\r]*\<\/name\>[\s\n\t\r]*\<value\>[\s\n\t\r]*(\<boolean\>)?[\s\n\t\r]*([0|1]{1})[\s\n\t\r]*(\<\/boolean\>)?[\s\n\t\r]*\<\/value\>[\s\n\t\r]*\<\/member\>/is", $result['XML'], $matches1) and preg_match("/\<member\>[\s\n\t\r]*\<name\>[\s\n\t\r]*message[\s\n\t\r]*\<\/name\>[\s\n\t\r]*\<value\>[\s\n\t\r]*(\<string\>)?[\s\n\t\r]*([^\<]*)[\s\n\t\r]*(\<\/string\>)?[\s\n\t\r]*\<\/value\>[\s\n\t\r]*\<\/member\>/is", $result['XML'], $matches2)) {
        return [(int) $matches1[2], (string) $matches2[2]];
    }

    if (!empty($result['ERR'])) {
        return [2, trim(strip_tags($result['ERR']))];
    }

    return [3, $nv_Lang->getModule('rpc_error_unknown')];
}

/**
 * nv_rpcXMLCreate()
 *
 * @param string $webtitle
 * @param string $webhome
 * @param string $linkpage
 * @param string $webrss
 * @param string $method
 * @return false|string
 */
function nv_rpcXMLCreate($webtitle, $webhome, $linkpage, $webrss = '', $method = 'weblogUpdates.ping')
{
    if ($method != 'weblogUpdates.ping') {
        $method = 'weblogUpdates.extendedPing';
    }

    $xml = new DOMDocument('1.0');
    $xml->formatOutput = true;
    $xml->preserveWhiteSpace = false;
    $xml->substituteEntities = false;
    $methodCall = $xml->appendChild($xml->createElement('methodCall'));
    $methodName = $methodCall->appendChild($xml->createElement('methodName'));
    $methodName->nodeValue = $method;

    $params = $methodCall->appendChild($xml->createElement('params'));
    $param1 = $params->appendChild($xml->createElement('param'));
    $value1 = $param1->appendChild($xml->createElement('value'));
    $value1->nodeValue = $webtitle;
    // Tên bài viết hoặc tên site

    $param2 = $params->appendChild($xml->createElement('param'));
    $value2 = $param2->appendChild($xml->createElement('value'));
    $value2->nodeValue = $webhome;
    // Trang chủ: vinades.vn

    if ($method == 'weblogUpdates.extendedPing') {
        $param3 = $params->appendChild($xml->createElement('param'));
        $value3 = $param3->appendChild($xml->createElement('value'));
        $value3->nodeValue = $linkpage;
        // Đường dẫn đến bài viết

        if (!empty($webrss)) {
            $param4 = $params->appendChild($xml->createElement('param'));
            $value4 = $param4->appendChild($xml->createElement('value'));
            $value4->nodeValue = $webrss;
        }
    }

    return $xml->saveXML();
}
