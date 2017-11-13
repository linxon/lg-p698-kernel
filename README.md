Подготовка к компиляции
=======================

* Для работы необходимо скачать и расспаковать исходники ядра, которые можно найти на официальном сайте: http://opensource.lge.com/osSch/list?types=ALL&search=LGP698 (на практике использовался архив "LGP698F(Optimus Net)_Android_GB_LGP698Fv10b")
  
* Расспаковать LGP698F(Optimus Net)_Android_GB_LGP698Fv10b.zip/**gelatods_kernel.tar.gz**

* Для компиляции ядра требуется использовать тулчейн версии 67-68 2009 года. Использовался: **arm-2009q3-67-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2**. Скачиваем: https://ayera.dl.sourceforge.net/project/iadfilehost/devtools/arm-2009q3-67-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
  и расспаковываем не "куда-нибудь", а рядышком с исходниками

* Поместить каталог с патчами "patches" в корень каталога с исходниками ядра

* Туда же, в корень, поместить скрипт "android_buildenv.sh" и сделаеть его исполняемым
  ~~~
  $ chmod u+x android_buildenv.sh"
  ~~~

* После чего, изменить пути к toolchain'у в скрипте
  **TC_DIR="/tmp/linxon-tmp-files/arm-2009q3"**

* Теперь, вы можете использовать этот скрипт для модификации/компиляции ядра
  ~~~
  $ ./android_buildenv.sh make menuconfig
  $ ./android_buildenv.sh make -j9
  ~~~
