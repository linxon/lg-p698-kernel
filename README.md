Подготовка к компиляции
=======================

* Для работы необходимо скачать и расспаковать исходники ядра, которые можно найти на официальном сайте: http://opensource.lge.com/osSch/list?types=ALL&search=LGP698 (на практике использовался архив "LGP698F(Optimus Net)_Android_GB_LGP698Fv10b")
  
* Расспаковать kernel/LGP698F(Optimus Net)_Android_GB_LGP698Fv10b.zip/gelatods_kernel.tar.gz

* Для компиляции ядра требуется использовать тулчейн версии 67-68 2009 года
  на практике использовался: arm-2009q3-67-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2

* Поместить каталог с патчами "patches" в корень каталога с исходниками ядра

* Туда же поместить скрипт "android_buildenv.sh" и сделаеть его исполняемым
  ~~~
  $ chmod u+x android_buildenv.sh"
  ~~~

* Теперь, вы можете использовать этот скрипт для модификации/компиляции ядра
  ~~~
  $ ./android_buildenv.sh make menuconfig
  $ ./android_buildenv.sh make -j9
  ~~~
