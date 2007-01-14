sr= 44100 
kr= 882
ksmps= 50 
nchnls= 1 

giusereverb init 0
ginoisereverbonly init 0

garev  init 0  ;dumps any previous information in garev

gisaw ftgen 0, 0, 4096, 10, 1, .5, .333, .25, .2, .167, .1428, .125, .111, .1, .0909, .0833, .0769, .0714, .0667, .0625  ; SAW

gireson11 ftgen 0, 0, 256, 5, 1, 8, 150, 2, 170, 2, 180, 4, 190, 8, 200, 16, 200, 8, 190, 4, 180, 2, 170, 4, 150, 72, 1, 0, -1, 8, -150, 2, -180, 4, -190, 8, -200, 16, -200, 8, -190, 4, -180, 2, -170, 4, -150, 72, -1

gimsrtub ftgen 0, 0,  8193, 7, -.8, 934, -.79, 934, -.77, 934, -.64, 1034, -.48, 520, .47, 2300, .48, 1536, .48

gimsrsin ftgen 0, 0, 8193, 10, 1
;gimsrsin ftgen 0, 0, 1024, 10, 1

gimsrsqr	ftgen 0, 0, 8193, 7, 1,  4096, 1, 0, -1, 4096, -1

gimsrdon1 ftgen 0, 0, 256, 5, 1, 8, 150, 2, 170, 2, 180, 4, 190, 8, 200, 16, 200, 8, 190, 4, 180, 2, 170, 4, 150, 72, 1, 0, -1, 8, -150, 2, -180, 4, -190, 8, -200, 16, -200, 8, -190, 4, -180, 2, -170, 4, -150, 72, -1

gimsrdon2 ftgen 0, 0, 64, 5, 1, 2, 120, 60, 1, 1, 0.001, 1

gimsrdonrsquare ftgen 0, 0, 1024, 10, 1.5, 0, .333333, 0, .2, 0,.142857, 0, .111111, 0,  .090909, 0, .076923, 0.066667, ; Rounded Square
gimsrdonsquare ftgen 0, 0, 1024, 10, 1, 0, .333333, 0,.2, 0, .142857,  0,  .111111, 0,  .090909, 0,     .076923 ; Square
gimsrdon4 ftgen 0, 0, 2048, 7, 0, 12, 1, 1000, 1, 24, -1, 1000, -1, 12, 0
gimsrdon5 ftgen 0,  0, 1024, 10, 1, .7, .7, .7, .7, .7, .7, .7, .7, .7,  .4, .4, .4, .4, .3, .3, .3, .3, .2, .2, .2, .2

;gisquarepulse116  ftgen 0, 0, 1024, 7, 0, 0, 1,64,1, 0, 0,960,0
;gisquarepulse116  ftgen 0, 0, 1024, 7, 0, 1, 1,62,1, 1, 0,960,0
gisquarepulse116  ftgen 0, 0, 1024, 7, 0, 1, 0.8, 1, 1,60,1, 1, 0.8, 1, 0,960,0
gisquarepulse132  ftgen 0, 0, 2048, 7, 0, 1, 0.8, 1, 1,60,1, 1, 0.8, 1, 0,1984,0

;gipokeyft = gisaw
gipokeyft = gimsrdon1
;gipokeyft = gimsrtub
;gipokeyft = gimsrsin
gipokeydist15ft = gisquarepulse116
gipokeydist31ft = gisquarepulse132

opcode declick0, a, a

ain     xin
;aenv    linseg 0, 0.02, 1, p3 - 0.02, 1
aenv    linseg 1, p3 - 0.001, 1, 0.001, 1.5
xout ain * aenv
endop

opcode mydeclick, a, iiiiii
ip4,ip5,ip6,ip7,ip8,ip9  xin;
istartamp = (ip6 != 0) ? 0 : (ip8+ip5)/2/ip5
iendamp = (ip7 != 0) ? 0 : (ip9+p5)/2/ip5
adeclick linseg istartamp, .005, 1, p3-.010, 1, .005, iendamp
xout adeclick
endop

opcode smoothamp, k, iiii
idur,iprevamp,iamp,iendamp xin
kdeclick linseg iprevamp, idur/2, iamp, idur/2, iendamp
xout kdeclick
endop

opcode declickamp, k, iiii
idur,iprevamp,iamp,iendamp xin
kdeclick linseg iprevamp, .005, iamp, p3-.010, iamp, 0.005, iendamp
xout kdeclick
endop

opcode declickfreq, k, iii
idur,iprevfreq,ifreq xin
kdeclick linseg iprevfreq, .005, ifreq, p3-.005, ifreq
xout kdeclick
endop

opcode scorefreq, i, i
ifnum xin
xout ifnum
endop

opcode scoreamp, i, i
ianum xin
;xout ianum
xout ianum*1000
endop

instr 99
  irevdur = 1.5
  i_filt_frq_start = 2000
  i_filt_frq_end = 1000
  ilen = irevdur
  ksaw    oscil 1000,2       ,gisaw
  k_flt_freq    line i_filt_frq_start,ilen,i_filt_frq_end
  ao reverb garev, irevdur
  ar  reson garev,ksaw,100, 2
  out ao
  garev = 0
endin

instr 10
idur = abs(p3)
ifreq scorefreq p4
iamp scoreamp p5
idist = p6
idistsize = p7
idistnum = p8
iskipinit = 1
tigoto skipinit
iskipinit = 0
iprevfreq = ifreq
iprevamp = 0
skipinit:
iendamp = (p3 > 0) ? 0 : iamp
kdeclickamp declickamp idur,iprevamp,iamp,iendamp
kdeclickfreq declickfreq idur,iprevfreq,ifreq

inoise = 0
if (idist == 8) then
asound randh iamp, ifreq
inoise = 1
elseif (idist == 1) then
;asound smoothamp idur,iprevamp,iamp,iendamp
asound linseg iamp,idur,iamp
elseif (idistsize == 15) then
asound0 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 0, iskipinit
asound1 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 1/15, iskipinit
asound2 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 2/15, iskipinit
asound3 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 3/15, iskipinit
asound4 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 4/15, iskipinit
asound5 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 5/15, iskipinit
asound6 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 6/15, iskipinit
asound7 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 7/15, iskipinit
asound8 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 7/15, iskipinit
asound9 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 9/15, iskipinit
asound10 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 10/15, iskipinit
asound11 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 11/15, iskipinit
asound12 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 12/15, iskipinit
asound13 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 13/15, iskipinit
asound14 oscilikt kdeclickamp/2, kdeclickfreq/7.5, gipokeydist15ft, 14/15, iskipinit
asound	sum	\
			asound0 * ((idistnum)&1),\
			asound1 * ((idistnum>>1)&1),\
			asound2 * ((idistnum>>2)&1),\
			asound3 * ((idistnum>>3)&1),\
			asound4 * ((idistnum>>4)&1),\
			asound5 * ((idistnum>>5)&1),\
			asound6 * ((idistnum>>6)&1),\
			asound7 * ((idistnum>>7)&1),\
			asound8 * ((idistnum>>8)&1),\
			asound9 * ((idistnum>>9)&1),\
			asound10 * ((idistnum>>10)&1),\
			asound11 * ((idistnum>>11)&1),\
			asound12 * ((idistnum>>12)&1),\
			asound13 * ((idistnum>>13)&1),\
			asound14 * ((idistnum>>14)&1)
elseif (idistsize == 31) then
asound0 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 0, iskipinit
asound1 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 1/31, iskipinit
asound2 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 2/31, iskipinit
asound3 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 3/31, iskipinit
asound4 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 4/31, iskipinit
asound5 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 5/31, iskipinit
asound6 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 6/31, iskipinit
asound7 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 7/31, iskipinit
asound8 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 8/31, iskipinit
asound9 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 9/31, iskipinit
asound10 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 10/31, iskipinit
asound11 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 11/31, iskipinit
asound12 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 12/31, iskipinit
asound13 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 13/31, iskipinit
asound14 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 14/31, iskipinit
asound15 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 15/31, iskipinit
asound16 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 16/31, iskipinit
asound17 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 17/31, iskipinit
asound18 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 18/31, iskipinit
asound19 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 19/31, iskipinit
asound20 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 20/31, iskipinit
asound21 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 21/31, iskipinit
asound22 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 22/31, iskipinit
asound23 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 23/31, iskipinit
asound24 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 24/31, iskipinit
asound25 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 25/31, iskipinit
asound26 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 26/31, iskipinit
asound27 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 27/31, iskipinit
asound28 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 28/31, iskipinit
asound29 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 29/31, iskipinit
asound30 oscilikt kdeclickamp/2, kdeclickfreq/15.5, gipokeydist31ft, 30/31, iskipinit
asound	sum	\
			asound0 * ((idistnum)&1),\
			asound1 * ((idistnum>>1)&1),\
			asound2 * ((idistnum>>2)&1),\
			asound3 * ((idistnum>>3)&1),\
			asound4 * ((idistnum>>4)&1),\
			asound5 * ((idistnum>>5)&1),\
			asound6 * ((idistnum>>6)&1),\
			asound7 * ((idistnum>>7)&1),\
			asound8 * ((idistnum>>8)&1),\
			asound9 * ((idistnum>>9)&1),\
			asound10 * ((idistnum>>10)&1),\
			asound11 * ((idistnum>>11)&1),\
			asound12 * ((idistnum>>12)&1),\
			asound13 * ((idistnum>>13)&1),\
			asound14 * ((idistnum>>14)&1),\
			asound15 * ((idistnum>>15)&1),\
			asound16 * ((idistnum>>16)&1),\
			asound17 * ((idistnum>>17)&1),\
			asound18 * ((idistnum>>18)&1),\
			asound19 * ((idistnum>>19)&1),\
			asound20 * ((idistnum>>20)&1),\
			asound21 * ((idistnum>>21)&1),\
			asound22 * ((idistnum>>22)&1),\
			asound23 * ((idistnum>>23)&1),\
			asound24 * ((idistnum>>24)&1),\
			asound25 * ((idistnum>>25)&1),\
			asound26 * ((idistnum>>26)&1),\
			asound27 * ((idistnum>>27)&1),\
			asound28 * ((idistnum>>28)&1),\
			asound29 * ((idistnum>>29)&1),\
			asound30 * ((idistnum>>30)&1)
else
asound oscilikt kdeclickamp, kdeclickfreq, gipokeyft, 0, 1
endif
if (giusereverb > 0) then
if (ginoisereverbonly < 1 || inoise < 1) then
out asound * 0.8
endif
garev = garev + asound * 0.2
else
out asound
endif
iprevfreq = ifreq
iprevamp = iamp
endin

instr 1
asound subinstr 10, p4,p5,p6,p7,p8
out asound
endin

instr 2
asound subinstr 10, p4,p5,p6,p7,p8
out asound
endin

instr 3
asound subinstr 10, p4,p5,p6,p7,p8
out asound
endin

instr 4
asound subinstr 10, p4,p5,p6,p7,p8
out asound
endin
