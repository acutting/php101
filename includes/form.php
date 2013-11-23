<?php

function form_get_data($form_fields, $request) {
    $return_value = array();

    foreach ($form_fields as $field_name) {
        $return_value[$field_name] = isset($request[$field_name]) ? $request[$field_name] : '';
    }

    return $return_value;
}

function form_is_valid($form, $required_fields) {
    $valid = true;

    foreach ($required_fields as $field_name) {
        if ($form[$field_name] === '') {
            $valid = false;
            break;
        }
    }

    return $valid;
}