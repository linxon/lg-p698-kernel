Подготовка к компиляции
=======================

* Для работы необходимо скачать и расспаковать исходники ядра, которые можно найти на официальном сайте: http://opensource.lge.com/osSch/list?types=ALL&search=LGP698 (на практике использовался архив "LGP698F(Optimus Net)_Android_GB_LGP698Fv10b")
  
* Расспаковать LGP698F(Optimus Net)_Android_GB_LGP698Fv10b.zip/**gelatods_kernel.tar.gz**

* Для компиляции ядра требуется использовать тулчейн **arm-none-linux-gnueabi** версии 67-68 2009 года. Скачиваем: https://ayera.dl.sourceforge.net/project/iadfilehost/devtools/arm-2009q3-67-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
  и расспаковываем не "куда-нибудь", а рядышком с исходниками

* Поместить каталог с патчами **patches** в корень каталога с исходниками ядра

* Туда же, в корень, поместить скрипт **android_buildenv.sh** и сделаеть его исполняемым
  ~~~
  linxon@cirno-chan: ~/WorkDir $ chmod u+x android_buildenv.sh"
  ~~~

* После чего, изменить пути к toolchain'у в скрипте
  **TC_DIR="/tmp/linxon-tmp-files/arm-2009q3"**

* Теперь, вы можете использовать этот скрипт для модификации/компиляции ядра
  ~~~
  linxon@cirno-chan: ~/WorkDir $ ./android_buildenv.sh make menuconfig
  linxon@cirno-chan: ~/WorkDir $ ./android_buildenv.sh make -j9
  ~~~


Установка ядра
==============

После успешной компиляции вы должны увидеть сообщение:
~~~
  ...
  AS      arch/arm/boot/compressed/piggy.gzip.o
  CC      drivers/usb/storage/ums-jumpshot.mod.o
  CC      drivers/usb/storage/ums-karma.mod.o
  LD      arch/arm/boot/compressed/vmlinux
  CC      drivers/usb/storage/ums-onetouch.mod.o
  OBJCOPY arch/arm/boot/zImage
  Kernel: arch/arm/boot/zImage is ready
  ...
~~~

* Нам необходимо получить загрузочный раздел **boot**
  ~~~
  linxon@cirno-chan: ~/WorkDir $ adb shell
  # cat /proc/mtd
  dev:    size   erasesize  name
  mtd0: 00500000 00020000 "boot" <<<----
  mtd1: 0dc00000 00020000 "system"
  mtd2: 00500000 00020000 "recovery"
  mtd3: 002c0000 00020000 "lgdrm"
  ...

  # cat /dev/mtd/mtd0 > /data/boot.img
  # ^D
  linxon@cirno-chan: ~/WorkDir $ adb pull /data/boot.img
  ~~~

* Установить программу "abootimg" для работы с boot разделами
  ~~~
  linxon@cirno-chan: ~/WorkDir $ sudo emerge -av dev-util/abootimg
  ~~~

* Разобрать раздел командой:
  ~~~
  linxon@cirno-chan: ~/WorkDir $ mkdir boot && mv boot.img boot && cd boot
  linxon@cirno-chan: ~/WorkDir/boot $ abootimg -x boot.img 
  writing boot image config in bootimg.cfg
  extracting kernel in zImage
  extracting ramdisk in initrd.img
  linxon@cirno-chan: ~/WorkDir/boot $ ls
  boot.img  bootimg.cfg  initrd.img  zImage
  linxon@cirno-chan: ~/WorkDir/boot $
  ~~~

* Заменить образ ядра zImage своим, который находится в 
  ~~~
  Kernel: arch/arm/boot/zImage is ready
  ~~~
  
* Сформировать новый образ командой:
  ~~~
  linxon@cirno-chan: ~/WorkDir/boot $ abootimg --create myboot.img -f bootimg.cfg -k zImage -r initrd.img
  ~~~
  и залить на смартфон с помощью adb:
  ~~~
  linxon@cirno-chan: ~/WorkDir/boot $ adb push myboot.img /data/
  ~~~

* Пишем измененный раздел **boot** в **/dev/mtd/mtd0** (убедимся, что у нас присутствует на смартфоне утилита **flash_image**):
  ~~~
  linxon@cirno-chan: ~/WorkDir/boot $ adb shell
  # flash_image --help
  # usage: flash_image partition file.img
  #
  # cat /dev/zero >> /dev/mtd/mtd0
  # flash_image boot /data/myboot.img
  # reboot
  linxon@cirno-chan: ~/WorkDir/boot $
  ~~~
