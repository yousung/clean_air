<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class KakaoRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
        ];
    }

    public function getQuery()
    {
        return [
            'x' => $this['x'],
            'y' => $this['y'],
            'input_coord' => 'WGS84',
            'output_coord' => 'WTM',
        ];
    }

    public function getHeader()
    {
        $key = config('Api.kakao');

        return [
            'Authorization' => "KakaoAK {$key}", ];
    }
}
