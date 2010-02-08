<CsoundSynthesizer>
<CsOptions>
-d -m229 -o dac -T
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1

; disable triggering of instruments by MIDI events
massign 0, 0
pgmassign 0, 0

; initialize FluidSynth
gifld fluidEngine
gisf2 fluidLoad "/usr/share/sounds/sf2/FluidR3_GM.sf2", gifld
fluidProgramSelect gifld, 1, gisf2, 0, 0
fluidProgramSelect gifld, 2, gisf2, 0, 0

gichanprog ftgen 704, 0, 16, -2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
gichancount ftgen 705, 0, 16, -2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
gichanofftime ftgen 706, 0, 16, -2, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8
gichanbend ftgen 707, 0, 16, -2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
gichannote ftgen 708, 0, 16, -2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

; velocity mapping
givelocitymap ftgen 505, 0, 128, 5, 0.1, 128, 1

; tables required for voice instrument
; Table #1, a sine wave.
gisine ftgen 101, 0, 4096, 10, 1
; gisine ftgen 101, 0, 16384, 10, 1
; Table #2. exponential curve to for envelope of fof pulses
gifofenv ftgen 102, 0, 1024, 19, 0.5, 0.5, 270, 0.5
;Indexing used by voice selection
givoiceindex ftgen 103, 0, 16, -2, 0, 15, 30, 45, 60
; vowel voice parameters

gihndx_ooh = 0.68
gihndx_aah = 0.02
gihndxstart = 1

gihfund = 100
gihoct = 0
; gihvoice = 0
gihvoice = 2
gihmoddep = 0.22
gihmodfrq =  5.3
; gihmoddly = 0.5
gihmoddly = 0.01
gihmodris = 0.5
; gihvibdep = 0.032
gihvibdep = 0.082
gihtrmdep = 0.15
gihrvbmix = 0.5
gihrvbtim = 0.5
gihhfdiff = 0.1
gihris = 0.003
gihdur = 0.02
; gihdec =  0.007
gihdec =  0
gihamprand = 0
gihamprandF =  1
gihfrqrand = 0.5
gihfrqrandF = 10
gihHPF =  20
gihcf =  300
gihgain =  1
gihq =  3
gihEQlev =  1
gihChoDep =  0.5
gihChoRate =  0.25
gihVlLFOAmp =  0
gihVlLFOFrq =  1
gihVlRndAmp =  0
gihVlRndFrq =  1
gihporttime1 =  0.03
gihporttime2 = 0.05
gihrndfund =  0
gihFundRndF = 1.5
gihFundRndA = 0.002
gihOctave = 7
gihSemiStep = 0
gihRvbOnOff = 1
gihVlRndType = 0

gihjointime = 50
gihscale = 0.2
gihoffwait = 1

gihformantcount = 4
gihvoicepg1 = 52
gihvoicepg2 = 53
gihvoicepg3 = 54

; end vowel voice parameters

;FUNCTION TABLES STORING DATA FOR VARIOUS VOICE FORMANTS
;BASS
gif1 ftgen 1, 0, 5, -2, 600, 400, 250, 400, 350, ;FREQ
gif2 ftgen 2, 0, 5, -7, 1040, 1620, 1750, 750, 600, ;FREQ
gif3 ftgen 3, 0, 5, -2, 2250, 2400, 2600, 2400, 2400, ;FREQ
gif4 ftgen 4, 0, 5, -2, 2450, 2800, 3050, 2600, 2675, ;FREQ
gif5 ftgen 5, 0, 5, -2, 2750, 3100, 3340, 2900, 2950, ;FREQ
gif6 ftgen 6, 0, 5, -2, 0, 0, 0, 0, 0, ;dB
gif7 ftgen 7, 0, 5, -2, -7, -12, -30, -11, -20, ;dB
gif8 ftgen 8, 0, 5, -2, -9, -9, -16, -21, -32, ;dB
gif9 ftgen 9, 0, 5, -2, -9, -12, -22, -20, -28, ;dB
gif10 ftgen 10, 0, 5, -2, -20, -18, -28, -40, -36, ;dB
gif11 ftgen 11, 0, 5, -2, 60, 40, 60, 40, 40, ;BAND, WIDTH
gif12 ftgen 12, 0, 5, -2, 70, 80, 90, 80, 80, ;BAND, WIDTH
gif13 ftgen 13, 0, 5, -2, 110, 100, 100, 100, 100, ;BAND, WIDTH
gif14 ftgen 14, 0, 5, -2, 120, 120, 120, 120, 120, ;BAND, WIDTH
gif15 ftgen 15, 0, 5, -2, 130, 120, 120, 120, 120, ;BAND, WIDTH
;TENOR
gif16 ftgen 16, 0, 5, -2, 650, 400, 290, 400, 350, ;FREQ
gif17 ftgen 17, 0, 5, -2, 1080, 1700, 1870, 800, 600, ;FREQ
gif18 ftgen 18, 0, 5, -2, 2650, 2600, 2800, 2600, 2700, ;FREQ
gif19 ftgen 19, 0, 5, -2, 2900, 3200, 3250, 2800, 2900, ;FREQ
gif20 ftgen 20, 0, 5, -2, 3250, 3580, 3540, 3000, 3300, ;FREQ
gif21 ftgen 21, 0, 5, -2, 0, 0, 0, 0, 0, ;dB
gif22 ftgen 22, 0, 5, -2, -6, -14, -15, -10, -20, ;dB
gif23 ftgen 23, 0, 5, -2, -7, -12, -18, -12, -17, ;dB
gif24 ftgen 24, 0, 5, -2, -8, -14, -20, -12, -14, ;dB
gif25 ftgen 25, 0, 5, -2, -22, -20, -30, -26, -26, ;dB
gif26 ftgen 26, 0, 5, -2, 80, 70, 40, 40, 40, ;BAND, WIDTH
gif27 ftgen 27, 0, 5, -2, 90, 80, 90, 80, 60, ;BAND, WIDTH
gif28 ftgen 28, 0, 5, -2, 120, 100, 100, 100, 100, ;BAND, WIDTH
gif29 ftgen 29, 0, 5, -2, 130, 120, 120, 120, 120, ;BAND, WIDTH
gif30 ftgen 30, 0, 5, -2, 140, 120, 120, 120, 120, ;BAND, WIDTH
;COUNTER TENOR
gif31 ftgen 31, 0, 5, -2, 660, 440, 270, 430, 370, ;FREQ
gif32 ftgen 32, 0, 5, -2, 1120, 1800, 1850, 820, 630, ;FREQ
gif33 ftgen 33, 0, 5, -2, 2750, 2700, 2900, 2700, 2750, ;FREQ
gif34 ftgen 34, 0, 5, -2, 3000, 3000, 3350, 3000, 3000, ;FREQ
gif35 ftgen 35, 0, 5, -2, 3350, 3300, 3590, 3300, 3400, ;FREQ
gif36 ftgen 36, 0, 5, -2, 0, 0, 0, 0, 0, ;dB
gif37 ftgen 37, 0, 5, -2, -6, -14, -24, -10, -20, ;dB
gif38 ftgen 38, 0, 5, -2, -23, -18, -24, -26, -23, ;dB
gif39 ftgen 39, 0, 5, -2, -24, -20, -36, -22, -30, ;dB
gif40 ftgen 40, 0, 5, -2, -38, -20, -36, -34, -30, ;dB
gif41 ftgen 41, 0, 5, -2, 80, 70, 40, 40, 40, ;BAND, WIDTH
gif42 ftgen 42, 0, 5, -2, 90, 80, 90, 80, 60, ;BAND, WIDTH
gif43 ftgen 43, 0, 5, -2, 120, 100, 100, 100, 100, ;BAND, WIDTH
gif44 ftgen 44, 0, 5, -2, 130, 120, 120, 120, 120, ;BAND, WIDTH
gif45 ftgen 45, 0, 5, -2, 140, 120, 120, 120, 120, ;BAND, WIDTH
;ALTO
gif46 ftgen 46, 0, 5, -2, 800, 400, 350, 450, 325, ;FREQ
gif47 ftgen 47, 0, 5, -2, 1150, 1600, 1700, 800, 700, ;FREQ
gif48 ftgen 48, 0, 5, -2, 2800, 2700, 2700, 2830, 2530, ;FREQ
gif49 ftgen 49, 0, 5, -2, 3500, 3300, 3700, 3500, 2500, ;FREQ
gif50 ftgen 50, 0, 5, -2, 4950, 4950, 4950, 4950, 4950, ;FREQ
gif51 ftgen 51, 0, 5, -2, 0, 0, 0, 0, 0, ;dB
gif52 ftgen 52, 0, 5, -2, -4, -24, -20, -9, -12, ;dB
gif53 ftgen 53, 0, 5, -2, -20, -30, -30, -16, -30, ;dB
gif54 ftgen 54, 0, 5, -2, -36, -35, -36, -28, -40, ;dB
gif55 ftgen 55, 0, 5, -2, -60, -60, -60, -55, -64, ;dB
gif56 ftgen 56, 0, 5, -2, 50, 60, 50, 70, 50, ;BAND, WIDTH
gif57 ftgen 57, 0, 5, -2, 60, 80, 100, 80, 60, ;BAND, WIDTH
gif58 ftgen 58, 0, 5, -2, 170, 120, 120, 100, 170, ;BAND, WIDTH
gif59 ftgen 59, 0, 5, -2, 180, 150, 150, 130, 180, ;BAND, WIDTH
gif60 ftgen 60, 0, 5, -2, 200, 200, 200, 135, 200, ;BAND, WIDTH
;SOPRANO
gif61 ftgen 61, 0, 5, -2, 800, 350, 270, 450, 325, ;FREQ
gif62 ftgen 62, 0, 5, -2, 1150, 2000, 2140, 800, 700, ;FREQ
gif63 ftgen 63, 0, 5, -2, 2900, 2800, 2950, 2830, 2700, ;FREQ
gif64 ftgen 64, 0, 5, -2, 3900, 3600, 3900, 3800, 3800, ;FREQ
gif65 ftgen 65, 0, 5, -2, 4950, 4950, 4950, 4950, 4950, ;FREQ
gif66 ftgen 66, 0, 5, -2, 0, 0, 0, 0, 0, ;dB
gif67 ftgen 67, 0, 5, -2, -6, -20, -12, -11, -16, ;dB
gif68 ftgen 68, 0, 5, -2, -32, -15, -26, -22, -35, ;dB
gif69 ftgen 69, 0, 5, -2, -20, -40, -26, -22, -40, ;dB
gif70 ftgen 70, 0, 5, -2, -50, -56, -44, -50, -60, ;dB
gif71 ftgen 71, 0, 5, -2, 80, 60, 60, 70, 50, ;BAND, WIDTH
gif72 ftgen 72, 0, 5, -2, 90, 90, 90, 80, 60, ;BAND, WIDTH
gif73 ftgen 73, 0, 5, -2, 120, 100, 100, 100, 170, ;BAND, WIDTH
gif74 ftgen 74, 0, 5, -2, 130, 150, 120, 130, 180, ;BAND, WIDTH
gif75 ftgen 75, 0, 5, -2, 140, 200, 120, 135, 200, ;BAND, WIDTH

; k-rate version of fluidProgramSelect

opcode fluidProgramSelect_k, 0, kkkkk
  keng, kchn, ksf2, kbnk, kpre xin
        igoto     skipInit
  doInit:
        fluidProgramSelect i(keng), i(kchn), i(ksf2), i(kbnk), i(kpre)
        reinit    doInit
        rireturn
  skipInit:
endop

instr 103
 ; for some reason, a negative p3 does not make the instrument continuous
 ; force held note, and turn off 1 second after off
 ihold
 kofftime init 0
 if(p4 == 0) then
 	ktimenow times
 	if (kofftime == 0) then
 		kofftime = ktimenow
 	elseif (ktimenow - kofftime > gihoffwait) then
 		turnoff
 	endif
 else
 	kofftime = 0
 endif
 kinsttime timeinsts

 kamp portk p4, 0.05, -1
; itotdur = abs(p3)
 kch = p6
 kmidinn = p7
 kbend table kch, gichanbend
; kfreq = p5
 kbend portk kbend, 0.05, -1
 kfreq = cpsmidinn(kmidinn + kbend)
 kpg = p8

kporttime1 = gihporttime1
kporttime2 = gihporttime2
if ( kofftime ==  0 && p3 >= 0 && kinsttime < 0.01 ) then
kporttime1 = 0
kporttime2 = 0
endif

iolaps 		= 		14850	;MAXIMUM NUMBER OF OVERLAPS (OVERESTIMATE)
ifna  		= 		gisine ;WAVEFORM FOR GRAIN CONTENTS
ifnb  		= 		gifofenv ;EXPONENTIAL SHAPE USED FOR GRAIN ENVELOPING
itotdur  	= 		3600	;NOTE WILL LAST FOR 1 HOUR (OVERESTIMATE)

;FUNDEMENTAL/FORMANT INPUT FORMAT
ivoice table gihvoice, 103
if ( kpg == 53 ) then
kndx = gihndx_ooh  * gihformantcount
else
kndx = gihndx_aah  * gihformantcount
endif

; try to simulate waaa/wooo...
if ( kpg == 54 || kpg == 53 ) then ; syth voice
if ( kinsttime < 0.01 && kofftime ==  0 && p3 >= 0 ) then ; note start
 kndx = gihndxstart * gihformantcount
endif
endif

kfund 		= kfreq

;FUNDEMENTAL_RANDOM_OFFSET
irandfundrange 	=		gihrndfund
ifundrand 	random		irandfundrange, -irandfundrange
kFundRndi 	randomi		gihFundRndA, -gihFundRndA, gihFundRndF
kFundRndh 	randomh		gihFundRndA, -gihFundRndA, gihFundRndF
kFundRnd 	ntrpol		kFundRndi, kFundRndh, 0 ; gihFundRndType
kfund 		=		kfund*(1+ifundrand)*(1+kFundRnd)

;VOWEL_MODULATION
;kvowelLFO 	oscil		gihVlLFOAmp, gihVlLFOFrq, 101
kvowelLFO 	lfo		gihVlLFOAmp, gihVlLFOFrq, 0 ; i(gkLFOmode)
kvowelRndi 	randomi		-gihVlRndAmp, gihVlRndAmp, gihVlRndFrq
kvowelRndh 	randomh		-gihVlRndAmp, gihVlRndAmp, gihVlRndFrq
kvowelRnd 	ntrpol		kvowelRndi, kvowelRndh, gihVlRndType
kndx 		=		kndx+kvowelLFO+kvowelRnd
kndx 		mirror		kndx, 0, gihformantcount

;FOF_AMPLITUDE_BANDWIDTH_&_FORMANT_DERIVATION
k1form  		tablei		kndx, 1+ivoice
k1amp  		tablei 		kndx, 6+ivoice
k1amp 		=		ampdb(k1amp)
k1band  		tablei 		kndx, 11+ivoice

k2form  		tablei		kndx, 2+ivoice
k2amp  		tablei 		kndx, 7+ivoice
k2amp 		=		ampdb(k2amp)
k2band  		tablei 		kndx, 12+ivoice

k3form  		tablei		kndx, 3+ivoice
k3amp  		tablei 		kndx, 8+ivoice
k3amp 		=		ampdb(k3amp)
k3band  		tablei 		kndx, 13+ivoice

k4form  		tablei		kndx, 4+ivoice
k4amp  		tablei 		kndx, 9+ivoice
k4amp 		=		ampdb(k4amp)
k4band  		tablei 		kndx, 14+ivoice

k5form  		tablei		kndx, 5+ivoice
k5amp  		tablei 		kndx, 10+ivoice
k5amp 		=		ampdb(k5amp)
k5band  		tablei 		kndx, 15+ivoice

k1form 		portk		k1form, kporttime2, -1
k2form 		portk		k2form, kporttime2, -1
k3form 		portk		k3form, kporttime2, -1
k4form 		portk		k4form, kporttime2, -1
k5form 		portk		k5form, kporttime2, -1
k1band 		portk		k1band, kporttime2, -1
k2band 		portk		k2band, kporttime2, -1
k3band 		portk		k3band, kporttime2, -1
k4band 		portk		k4band, kporttime2, -1
k5band 		portk		k5band, kporttime2, -1
kfund 		portk		kfund,  kporttime1, -1

;VIBRATO
kamprnd 		randomi		-gihamprand, gihamprand, gihamprandF
kmoddep 		=		gihmoddep+kamprnd
kmoddep 		limit		kmoddep, 0, 1
kfrqrnd 		randomi		-gihfrqrand, gihfrqrand, gihfrqrandF
kmodfrq 		=		gihmodfrq+kfrqrnd
kmoddep 		limit		kmoddep, 0, 10
kmodenv 		linseg		0, gihmoddly+.00001, 0, gihmodris, 1, 1, 1
kvib 		oscili		gihvibdep*kmodenv*gihmoddep, kmodfrq, 101
kvib 		=		kvib+1
kfund 		=		kfund*kvib
ktrm 		oscil		gihtrmdep*.5*kmodenv*kmoddep, gihmodfrq, 101
ktrm 		=		ktrm+.5

a1  		fof 		k1amp, kfund, k1form, gihoct, k1band, gihris, gihdur, gihdec, iolaps, ifna, ifnb, itotdur, 0, 0, 1
a2  		fof 		k2amp, kfund, k2form, gihoct, k2band, gihris, gihdur, gihdec, iolaps, ifna, ifnb, itotdur, 0, 0, 1
a3  		fof 		k3amp, kfund, k3form, gihoct, k3band, gihris, gihdur, gihdec, iolaps, ifna, ifnb, itotdur, 0, 0, 1
a4  		fof 		k4amp, kfund, k4form, gihoct, k4band, gihris, gihdur, gihdec, iolaps, ifna, ifnb, itotdur, 0, 0, 1
a5  		fof 		k5amp, kfund, k5form, gihoct, k5band, gihris, gihdur, gihdec, iolaps, ifna, ifnb, itotdur, 0, 0, 1
avoice 		=		(a1+a2+a3+a4+a5) * ktrm * kamp * gihscale
; avoice 		=		(a1+a2+a3+a4+a5) * kamp
 outc avoice , avoice
endin

instr 1
  ; initialize channels
  kchn  init 1
  if (kchn == 1) then
lp2:
        fluidControl gifld, 192, kchn - 1, 0, 0
        fluidControl gifld, 176, kchn - 1, 7, 100
        fluidControl gifld, 176, kchn - 1, 10, 64
        loop_le   kchn, 1, 16, lp2
  endif 

  ; send any MIDI events received to FluidSynth
nxt:
  kst, kch, kd1, kd2 midiin
  kch = kch - 1
  if (kst != 0) then
; printks "midiin %f %f %f %f\n", 0.1, kst, kch, kd1, kd2
    if (kst != 192) then
      kpg table kch, gichanprog
      kcount table kch, gichancount
      if ( kpg == gihvoicepg1 || kpg == gihvoicepg2 || kpg == gihvoicepg3 ) then
        ; use local csound instrument
        if (kst == 144 && kd2 != 0) then ; note on
          kcount = kcount + 1
          tablew kcount, kch, gichancount
          ktime timek
          kofftime table kch, gichanofftime
          ; simulate slur if channel note off was very recent
          if (ktime - kofftime  < gihjointime ) then
            kdur = -1
          else
            kdur = 1
          endif
;          printks "ch %f time off %f on %f count %f\n", 0.1, kch, kofftime, ktime, kcount
;         kinst = 103 + kd1/100000 + kch/100  
          kinst = 103 +  kcount/100000 + kch/100
          kvol tablei kd2, givelocitymap
          tablew kd1, kch, gichannote
          kfreq = cpsmidinn(kd1)
;         printks "on event %f %f %f %f %f\n", 0.1,  kinst, 0, kdur, kvol, kfreq
          event "i", kinst, 0, kdur, kvol, kfreq, kch, kd1, kpg
;subinstr i(kinst), 0, i(kdur), i(kvol), i(kfreq)
;schedule i(kinst), 0, i(kdur), i(kvol), i(kfreq)
        elseif (kst == 128 || (kst == 144 && kd2 == 0)) then ; note off
;          kinst = 103
;         kinst = 103 +  kd1/100000 + kch/100
          kinst = 103 +  kcount/100000 + kch/100
          kfreq = cpsmidinn(kd1) ; + kbend)
          kdur = -1
          kvol = 0
;          printks "off event %f %f %f %f %f\n", 0.1,  kinst, 0, kdur, kvol, kfreq
          event "i", kinst, 0, -1, 0, kfreq, kch, kd1, kpg
          kcount = kcount - 1
          if(kcount < 0) then
            kcount = 0
          endif
          tablew kcount, kch, gichancount
          ktime timek
          tablew ktime, kch, gichanofftime
        elseif (kst == 224) then ; note bend
          kbend = (kd2 - 64)*24/64
          tablew kbend, kch, gichanbend
;          printks "bend event %f %f %f\n", 0.1, kch, kd2, kd1
        endif
      else
        fluidControl gifld, kst, kch - 1, kd1, kd2
      endif
    else
      tablew kd1, kch, gichanprog
      fluidProgramSelect_k gifld, kch - 1, gisf2, 0, kd1
    endif
    kgoto nxt
  endif

  aL, aR fluidOut gifld
        outs      aL, aR
endin

</CsInstruments>
<CsScore>
f0 36000

i1 0 3600
e

</CsScore>
</CsoundSynthesizer> 
