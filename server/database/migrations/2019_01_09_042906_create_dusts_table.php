<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateDustsTable extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::create('dusts', function (Blueprint $table) {
            $table->increments('id');

            $table->unsignedInteger('station_id');
            $table->double('dust10')->comment('미세먼지 pm10 1시간');
            $table->double('dust25')->comment('미세먼지 pm25 1시간');
            $table->datetime('date_time')->unique()->comment('측정시간');

            $table->timestamps();
            $table->foreign('station_id')->references('id')->on('stations')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down()
    {
        Schema::dropIfExists('dusts');
    }
}
