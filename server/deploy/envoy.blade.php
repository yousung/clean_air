@servers(['web' => 'air'])

@setup
  $username = 'air';                                          // 서버의 사용자 계정
  $remote = 'git@github.com:yousung/-server-dust-level.git';  // 깃허브 저장소 주소
  $base_dir = "/home/{$username}";                            // 웹서비스를 담을 기본 디렉터리
  $project_root = "{$base_dir}/web";                        // 프로젝트 루트 디렉터리
  $shared_dir = "{$base_dir}/shared";                         // 새 코드를 배포해도 이전 코드와 연속성을 유지하는 하는 파일/디렉터리 모음
  $release_dir = "{$base_dir}/releases";                  // 깃허브에서 받은 코드(릴리스)를 담을 디렉터리
  $distname = 'release_' . date('YmdHis');                    // 릴리스 이름(디렉터리 이름)

  $required_dirs = [
    $shared_dir,
    $release_dir,
  ];

  $shared_item = [
    "{$shared_dir}/.env" => "{$release_dir}/{$distname}/.env",
    "{$shared_dir}/storage" => "{$release_dir}/{$distname}/storage",
    "{$shared_dir}/cache" => "{$release_dir}/{$distname}/bootstrap/cache",
  ];
@endsetup


@task('air', ['on' => ['web']])
  @foreach ($required_dirs as $dir)
    [ ! -d {{ $dir }} ] && mkdir -p {{ $dir }};
  @endforeach

  echo 'GIT Clone';
  cd {{ $release_dir }} && git clone -b master {{ $remote }} {{ $distname }};

  [ ! -f {{ $shared_dir }}/.env ] && cp {{ $release_dir }}/{{ $distname }}/.env.example {{ $shared_dir }}/.env;
  [ ! -d {{ $shared_dir }}/storage ] && cp -R {{ $release_dir }}/{{ $distname }}/storage {{ $shared_dir }};
  [ ! -d {{ $shared_dir }}/cache ] && cp -R {{ $release_dir }}/{{ $distname }}/bootstrap/cache {{ $shared_dir }};

  @foreach($shared_item as $global => $local)
    [ -f {{ $local }} ] && rm {{ $local }};
    [ -d {{ $local }} ] && rm -rf {{ $local }};
    ln -nfs {{ $global }} {{ $local }};
  @endforeach

  echo 'Composer Install';
  cd {{ $release_dir }}/{{ $distname }} && composer install --prefer-dist --no-scripts --no-dev;
  ln -nfs {{ $release_dir }}/{{ $distname }} {{ $project_root }};

  sudo chmod -R 777 {{ $shared_dir }}/storage;
  sudo chmod -R 777 {{ $shared_dir }}/cache;
  sudo chgrp -h -R www-data {{ $release_dir }}/{{ $distname }};

  {{--echo 'Data Migrate';--}}
  {{--cd {{ $release_dir }}/{{ $distname }} && php artisan migrate --force;--}}

  echo 'Old Date Delete';
  cd {{ $release_dir }} && ls -td1 * | tail -n +3 | sudo xargs rm -fr

  echo 'route & config Clear Cache'
  cd {{ $project_root }} && php artisan route:clear && php artisan config:clear;

  echo 'route & config Set Cache'
  cd {{ $project_root }} && php artisan route:cache && php artisan config:cache;

  sudo service supervisor restart;
  cd {{ $project_root }} && php artisan queue:restart;

  sudo service nginx reload;
  sudo service php7.1-fpm reload;
@endtask
