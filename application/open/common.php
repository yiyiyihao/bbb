<?php


function dataFormat($code = 0, $msg = '', $data = [])
{
    if (func_num_args() == 1) {
        $args = func_get_arg(0);
        $code = (string)array_shift($args);
        $msg = (string)array_shift($args);
        $data = array_shift($args);
    }
    if (!empty($data)) {
        $data = recursion(json_decode(json_encode($data), true));
    }
    $result = [
        'code' => (string)$code,
        'msg' => (string)$msg,
    ];
    if (empty($data)) {
        return $result;
    }
    if (is_array($data) && count($data) == 1 && key_exists('data', $data)) {
        return array_merge($result, $data);
    } else {
        $result['data'] = $data;
        return $result;
    }
}

function recursion($arr = [])
{
    if (empty($arr)) {
        return [];
    }
    $arr = json_decode(json_encode($arr), true);
    foreach ($arr as $k => $v) {
        if (is_array($v)) {
            $arr[$k] = recursion($v);
        } else {
            $arr[$k] = strval($v);
        }
    }
    return $arr;
}