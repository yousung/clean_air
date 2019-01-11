<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StationRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
        ];
    }

    public function city():String
    {
        return urlencode($this->input('city'));
    }
}
