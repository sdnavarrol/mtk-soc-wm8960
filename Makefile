OPENWRT = ${HOME}/irt/hdl/openwrt
KERNEL = ${OPENWRT}/build_dir/target-mipsel_24kc_musl/linux-ramips_mt76x8/linux-4.14.63
#KERNEL = ${HOME}/irt/hdl/linux-4.14.63
STAGING_DIR = ${OPENWRT}/staging_dir/
LD=${OPENWRT}/staging_dir/toolchain-mipsel_24kc_gcc-7.3.0_musl/bin/mipsel-openwrt-linux-musl-ld
CROSS_COMPILE="mipsel-openwrt-linux-musl-"
EXTRA_LDSFLAGS="-I${OPENWRT}/build_dir/target-mipsel_24kc_musl/linux-ramips_mt76x8"
KBUILD_HAVE_NLS=no
CONFIG_SHELL="/bin/bash"
KBUILD_CFLAGS += -DCONFIG_MT7628
#KBUILD_CFLAGS += -DCONFIG_RALINK_MT7628
KBUILD_CFLAGS += -DRALINK_SYSCTL_BASE=0xB0000000
KBUILD_CFLAGS += -DRALINK_INTCL_BASE=0xB0000200
KBUILD_CFLAGS += -DRALINK_PIO_BASE=0xB0000600
KBUILD_CFLAGS += -DRALINK_I2S_BASE=0xB0000A00
KBUILD_CFLAGS += -DRALINK_GDMA_BASE=0xB0002800
KBUILD_CFLAGS += -DCONFIG_GDMA_EVERYBODY
KBUILD_CFLAGS += -DCONFIG_SND_MT76XX_SOC
KBUILD_CFLAGS += -DCONFIG_I2S_WM8960
KBUILD_CFLAGS += -DCONFIG_I2S_MCLK_12P288MHZ
#KBUILD_CFLAGS += -DCONFIG_I2S_MCLK_12MHZ
KBUILD_CFLAGS += -DCONFIG_GDMA_EVERYBODY
KBUILD_CFLAGS += -DSURFBOARDINT_DMA=15
KBUILD_CFLAGS += -DRALINK_INTCTL_DMA=128
KBUILD_CFLAGS += -DCONFIG_SND_SOC_WM8960

#snd-soc-mt76xx-i2s-ctl-objs := i2s_ctrl.o i2s_debug.o

#obj-m += i2s_ctrl.o i2s_debug.o mt76xx_i2s.o mt76xx_pcm.o  mt76xx_machine.o ralink_gdma.o i2c_wm8960.o wm8960.o 
snd-soc-mt76xx-i2s-ctl-objs := i2s_ctrl.o i2s_debug.o
snd-soc-mt76xx-pcm-objs := mt76xx_pcm.o
snd-soc-mt76xx-i2s-objs := mt76xx_i2s.o
obj-m += snd-soc-mt76xx-pcm.o
obj-m += snd-soc-mt76xx-i2s-ctl.o snd-soc-mt76xx-i2s.o
snd-soc-mt76xx-machine-objs := mt76xx_machine.o
snd-soc-wm8960-objs := wm8960.o
obj-m += i2c_wm8960.o mtk_ralink_gdma.o snd-soc-mt76xx-machine.o
obj-m += snd-soc-wm8960.o

all: clean build

build:
	make -C ${KERNEL} ARCH="mips" CC="${OPENWRT}/staging_dir/toolchain-mipsel_24kc_gcc-7.3.0_musl/bin/mipsel-openwrt-linux-musl-gcc"  M=$(PWD) modules
clean:
	make -C ${KERNEL} CC="${OPENWRT}/staging_dir/toolchain-mipsel_24kc_gcc-7.3.0_musl/bin/mipsel-openwrt-linux-musl-gcc"  M=$(PWD) clean
transfer:
	scp *.ko .asoundrc *.wav run.sh root@192.168.2.1:~