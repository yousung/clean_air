<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class DustRequest extends FormRequest
{


    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
//            'station' => 'required'
        ];
    }

    public function getAttributes()
    {
        return [
            'station' => '관측소'
        ];
    }

    public function station()
    {
        return urlencode($this->input('station'));
    }
}
