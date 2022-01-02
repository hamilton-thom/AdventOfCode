# -*- coding: utf-8 -*-
"""
Created on Wed Dec 22 07:21:45 2021

@author: hamil
"""


input = """on x=-20..26,y=-36..17,z=-47..7
on x=-20..33,y=-21..23,z=-26..28
on x=-22..28,y=-29..23,z=-38..16
on x=-46..7,y=-6..46,z=-50..-1
on x=-49..1,y=-3..46,z=-24..28
on x=2..47,y=-22..22,z=-23..27
on x=-27..23,y=-28..26,z=-21..29
on x=-39..5,y=-6..47,z=-3..44
on x=-30..21,y=-8..43,z=-13..34
on x=-22..26,y=-27..20,z=-29..19
off x=-48..-32,y=26..41,z=-47..-37
on x=-12..35,y=6..50,z=-50..-2
off x=-48..-32,y=-32..-16,z=-15..-5
on x=-18..26,y=-33..15,z=-7..46
off x=-40..-22,y=-38..-28,z=23..41
on x=-16..35,y=-41..10,z=-47..6
off x=-32..-23,y=11..30,z=-14..3
on x=-49..-5,y=-3..45,z=-29..18
off x=18..30,y=-20..-8,z=-3..13
on x=-41..9,y=-7..43,z=-33..15
on x=-54112..-39298,y=-85059..-49293,z=-27449..7877
on x=967..23432,y=45373..81175,z=27513..53682"""


input = """on x=-9..45,y=-15..37,z=-2..46
on x=-48..2,y=-11..37,z=3..48
on x=-47..4,y=-47..-3,z=-12..34
on x=-24..29,y=-12..40,z=-20..29
on x=-48..3,y=-38..16,z=-22..31
on x=-35..13,y=-10..43,z=-11..42
on x=-4..47,y=1..47,z=-26..18
on x=-49..1,y=-29..22,z=-44..2
on x=-12..33,y=-14..38,z=-9..35
on x=-44..8,y=0..46,z=-28..20
off x=-44..-31,y=-37..-21,z=35..49
on x=-2..42,y=-49..-4,z=-10..39
off x=-26..-17,y=-38..-29,z=-32..-18
on x=-41..10,y=-1..49,z=-22..24
off x=-49..-35,y=-26..-15,z=11..24
on x=-5..47,y=-34..10,z=-3..42
off x=-16..-7,y=-9..0,z=-4..12
on x=-45..1,y=-25..22,z=-2..49
off x=21..40,y=30..44,z=-16..1
on x=-11..37,y=-44..1,z=-20..25
on x=7379..15679,y=62885..66145,z=40785..66699
on x=55922..93809,y=1651..21593,z=-29830..-6845
on x=-31566..-20771,y=49570..87512,z=-38744..-20396
on x=4993..41166,y=-27079..-6497,z=-88189..-66473
on x=60741..69319,y=-13925..8370,z=-62720..-33863
on x=34284..42689,y=-71439..-58324,z=22610..47957
on x=8592..42171,y=-65708..-43885,z=-61206..-46568
on x=64371..79931,y=28477..37185,z=13392..20753
on x=-59117..-37612,y=-64167..-37759,z=35921..54572
on x=-14064..20202,y=-90417..-70077,z=25371..40391
on x=-67395..-41025,y=17787..31773,z=-57128..-48199
on x=-70962..-46942,y=19586..45376,z=-54426..-31169
on x=31777..46666,y=-28152..-20207,z=-66876..-55373
on x=13530..27088,y=-90327..-70591,z=-1912..25782
on x=40408..67678,y=38887..66828,z=-30776..-13301
on x=-29414..-16610,y=56466..86239,z=20871..32428
on x=-76113..-67766,y=37613..40645,z=-16702..13708
on x=-53053..-28552,y=57577..78562,z=14326..42575
on x=-58889..-42881,y=16768..21306,z=42955..76041
on x=-73073..-51398,y=46632..48316,z=20149..34615
on x=-66303..-54970,y=-61600..-49802,z=-11768..9094
on x=-53654..-27948,y=9591..45638,z=-71810..-58350
on x=-69622..-52612,y=-45011..-38959,z=24484..44518
on x=3515..15378,y=41121..59682,z=-61133..-55743
on x=-90134..-62577,y=208..23739,z=26851..46343
on x=65530..81406,y=42070..52596,z=-11235..13125
on x=64169..84257,y=-10178..17467,z=-29044..-16366
on x=17446..26654,y=-66194..-47798,z=-42530..-24698
on x=-58456..-32175,y=-57823..-50339,z=35867..54337
on x=47156..63257,y=-36128..-21908,z=33134..41699
on x=-48529..-31263,y=-62437..-39211,z=-56496..-37240
on x=-34149..-14003,y=-79123..-45929,z=-55215..-40418
on x=-84191..-64387,y=-11156..17366,z=31098..34346
on x=-82865..-68797,y=-5798..8421,z=28104..58202
on x=29311..45767,y=-88790..-62482,z=-29612..-214
on x=8842..27908,y=68184..82736,z=-55247..-19216
on x=-42756..-14515,y=74498..84491,z=-20007..4343
on x=-37638..-28150,y=-72221..-45636,z=49412..60164
on x=32841..44894,y=-62963..-55317,z=-44129..-18308
on x=41325..48341,y=14656..22614,z=-63334..-57171
on x=39491..70558,y=48229..67699,z=14708..39318
on x=-16935..-15423,y=72793..82573,z=-9454..8508
on x=28720..40689,y=29779..36750,z=-74342..-54201
on x=65984..88372,y=-3884..15208,z=19130..38834
on x=-85972..-61107,y=-27882..-5274,z=-23592..-4731
on x=-65737..-48051,y=-4370..32823,z=-51562..-27039
on x=53568..75174,y=13164..34585,z=-62900..-49637
on x=43348..67279,y=37890..47849,z=6060..34285
on x=-88633..-60579,y=-40956..-20401,z=-20101..8972
on x=-70097..-44904,y=37603..69889,z=-21021..-5234
on x=-76016..-71353,y=10592..39343,z=5961..25639
on x=26814..51079,y=-76683..-51852,z=-32221..-7926
on x=78022..90710,y=-6329..7380,z=-30398..3225
on x=-81947..-59036,y=6212..27865,z=-30191..-23650
on x=-14260..5518,y=-59292..-33347,z=-80781..-44527
on x=61127..77249,y=-44821..-16717,z=-15659..9963
on x=7812..29885,y=46232..56927,z=56252..66587
on x=-70864..-55068,y=36351..66673,z=2115..29365
on x=-21385..-5787,y=-24942..-1426,z=62656..77888
on x=21748..31508,y=44194..75368,z=42392..61013
on x=-30140..-13716,y=60038..82957,z=-55563..-22103
on x=15892..46641,y=28104..45417,z=-69780..-49812
on x=-35304..-14704,y=-69612..-54212,z=-64119..-43604
on x=-75511..-53167,y=-16408..-5573,z=-34276..-13669
on x=-49880..-26128,y=-78019..-53301,z=563..27150
on x=-3710..31007,y=635..31231,z=-89739..-67701
on x=16417..27647,y=59484..83416,z=-38071..-8125
on x=-55486..-36218,y=-18343..-1162,z=48973..70778
on x=6364..25168,y=-73763..-55266,z=-47439..-20212
on x=-77074..-63388,y=13325..37503,z=26475..47125
on x=47836..63427,y=-22005..-1081,z=-56895..-36496
on x=52594..78952,y=1602..34837,z=-55674..-29580
on x=9195..36803,y=-42634..-16959,z=49912..77645
on x=-43313..-9809,y=-61189..-27305,z=-73518..-57945
on x=-15098..-247,y=-84505..-61173,z=-6903..10359
on x=-14761..20062,y=42726..66812,z=-67450..-36194
on x=-6269..13514,y=27764..51152,z=-65770..-56309
on x=-11702..12085,y=4154..19444,z=74342..85810
on x=20250..40759,y=-12245..12965,z=-85663..-56952
on x=14397..31766,y=-77031..-60677,z=-13856..14510
on x=-57268..-50706,y=-61409..-55384,z=-8347..2644
on x=27634..48898,y=66690..87119,z=-27363..-7996
on x=11697..40665,y=-92019..-67357,z=-28564..-4579
on x=-23635..-7962,y=23732..32687,z=-83083..-62791
on x=40495..46668,y=-62018..-49602,z=-65022..-33630
on x=13198..30010,y=-82290..-65531,z=-17978..9547
on x=12582..25248,y=-22745..3631,z=70846..86218
on x=-26583..-5966,y=41977..55683,z=36463..75892
on x=-65277..-49356,y=37876..57024,z=-52763..-45440
on x=-64608..-41498,y=-8129..16874,z=50097..71345
on x=42175..49606,y=-70140..-50383,z=35730..40798
on x=54705..58189,y=-56152..-49341,z=-400..24932
on x=68337..79185,y=-25307..-6874,z=-3313..19891
on x=5018..29619,y=62462..81105,z=18248..30135
on x=-76041..-38663,y=38551..70709,z=-12671..23088
on x=-72729..-54213,y=-6076..24031,z=-57821..-37810
on x=43326..72010,y=20000..41816,z=51160..69275
on x=1558..30222,y=-73358..-70358,z=16312..51532
on x=-35043..-18417,y=-44261..-25881,z=-78549..-52077
on x=28098..46713,y=18474..22660,z=-78742..-54633
on x=-14412..8266,y=70802..80415,z=-14992..9258
on x=-26641..-7645,y=60425..75589,z=-43589..-23911
on x=-25876..-19902,y=53219..77507,z=-48144..-17584
on x=-43367..-22330,y=68271..77937,z=9057..20584
on x=-17237..2381,y=3583..28698,z=-94572..-73051
on x=-6829..3379,y=65792..90689,z=-5002..16981
on x=-54132..-45538,y=-78237..-50736,z=-11644..8605
on x=-59532..-53419,y=34745..56394,z=30582..53444
on x=-20732..5101,y=-77256..-61756,z=30478..35782
on x=14347..38867,y=9283..24381,z=-87398..-53279
on x=36595..57756,y=38640..51025,z=-58273..-44565
on x=-54582..-27927,y=-78804..-46081,z=13910..33182
on x=16349..35830,y=71332..87852,z=8157..16797
on x=-43956..-33473,y=33808..56755,z=42846..61246
on x=11314..13439,y=-38033..-17400,z=-76284..-68981
on x=46492..76990,y=8474..15734,z=-55742..-41584
on x=27131..36354,y=-29792..-5590,z=-74708..-55530
on x=52353..74451,y=33392..55689,z=19093..30505
on x=10590..26407,y=26646..44875,z=53669..85124
on x=10328..23456,y=52345..77588,z=31705..56684
on x=-46182..-26197,y=20916..52128,z=-61613..-51850
on x=-5902..15644,y=7302..32746,z=-89842..-71630
on x=-13813..21172,y=-87032..-70414,z=-36..11650
on x=-43300..-20544,y=-39391..-20796,z=-78685..-54411
on x=53826..59621,y=-22659..6182,z=34874..57854
on x=56180..78116,y=-17473..-11209,z=33329..48534
on x=-27987..-9324,y=45080..55335,z=48847..80731
on x=71719..89566,y=-25531..-10083,z=-22109..-12785
on x=-29430..-21311,y=-89432..-55080,z=14731..25873
on x=32126..44985,y=48444..71257,z=16998..38903
on x=24388..50981,y=-66328..-57172,z=-52521..-27884
on x=30463..45384,y=-7855..28748,z=-86869..-55644
on x=-67671..-45297,y=-29469..-5222,z=44296..53119
on x=35058..42106,y=-69099..-47111,z=40655..63310
on x=33046..64904,y=-70169..-43042,z=13896..36888
on x=-22322..-13112,y=-25157..-2838,z=-93853..-69670
on x=73781..84202,y=-1016..31182,z=9547..30589
on x=-72865..-63710,y=-50800..-28031,z=-15998..20829
on x=6767..15631,y=-17255..-11461,z=-97425..-59135
on x=25319..31792,y=-93050..-64825,z=8041..20183
on x=-70089..-30927,y=36115..69616,z=-39401..-14311
on x=62942..69074,y=-22392..-1078,z=-66440..-27451
on x=-13913..4148,y=-75097..-42466,z=35698..57507
on x=-85917..-59242,y=-11125..2601,z=19575..55603
on x=15134..42927,y=-79064..-64982,z=-1971..24343
on x=39880..58909,y=56469..72390,z=-1437..26115
on x=-21090..-12306,y=-94355..-77198,z=-29560..52
on x=-28671..-8856,y=45669..64627,z=31384..51891
on x=-75912..-56733,y=-23901..1139,z=28555..57092
on x=-47744..-10650,y=71138..83710,z=4554..27540
on x=25710..42555,y=-33622..-14274,z=52056..65528
on x=-76115..-63779,y=-29627..-15804,z=-1106..16981
on x=14189..34263,y=-62546..-38815,z=42727..81264
on x=7852..41042,y=31315..42334,z=55681..71183
on x=-88315..-67768,y=-8097..8232,z=22878..36892
on x=-75367..-48994,y=-65971..-49798,z=-331..14292
on x=-25718..1445,y=-80169..-61373,z=-57242..-32282
on x=-13075..7644,y=-14640..-3379,z=75167..96592
on x=35741..67984,y=-60591..-37834,z=-42879..-23133
on x=-26071..-15399,y=-54535..-33151,z=64373..77023
on x=70725..90684,y=8312..29942,z=-28004..2695
on x=54936..67698,y=10377..30841,z=-45783..-36371
on x=-2020..25407,y=-78434..-50839,z=-48610..-39223
on x=-45717..-43647,y=48801..70774,z=31062..45511
on x=34206..54314,y=-70584..-47392,z=-45786..-24983
on x=-49858..-27145,y=-8313..12257,z=-80733..-65761
on x=19194..48953,y=-76824..-50937,z=-38483..-20184
on x=-11056..8975,y=60011..77711,z=-47016..-22798
on x=23444..61412,y=-8792..27162,z=54757..77897
on x=-75528..-48686,y=-2534..13417,z=-72418..-47078
on x=21664..55288,y=9053..15264,z=54771..84777
on x=45230..57868,y=-35816..-19600,z=-70489..-40910
on x=30646..56513,y=-73290..-51396,z=-48109..-23594
on x=-19927..8133,y=20111..22064,z=-78790..-65966
on x=-73214..-50284,y=-42781..-29543,z=-52080..-40858
on x=59641..92804,y=-14320..9890,z=10580..32686
on x=6948..24112,y=59008..83939,z=9209..29435
on x=20747..42638,y=54010..87392,z=-10349..6792
on x=-82467..-56030,y=-63078..-36419,z=-18052..-7281
on x=43143..53517,y=-42852..-33677,z=-75322..-38352
on x=34903..68087,y=-53600..-43300,z=19263..37332
on x=-75090..-51229,y=39553..54421,z=-29984..-11983
on x=31297..41923,y=40810..55544,z=41336..65242
on x=48907..76926,y=44120..55019,z=19408..32113
on x=-28350..-11619,y=-96073..-68302,z=7131..23826
on x=-71444..-52453,y=-46437..-37331,z=-23610..-7727
on x=-90114..-62112,y=-11142..11966,z=10310..30329
on x=-8298..10663,y=-89901..-65346,z=26819..55136
on x=-83214..-52210,y=-28546..-6449,z=26105..44117
on x=-48292..-15887,y=-32421..-24179,z=-72733..-50252
on x=2675..6592,y=57643..77972,z=-45680..-31319
on x=-27301..-19021,y=52139..65771,z=40324..62506
on x=-15122..12261,y=76124..83252,z=-6966..26871
on x=-28135..-5592,y=42253..66391,z=61120..81631
on x=41458..59123,y=-65686..-28325,z=18007..42560
on x=-7254..2575,y=-37975..-25118,z=-83436..-55842
on x=-69756..-51850,y=-14700..11743,z=-64913..-57730
on x=46050..60943,y=29947..49852,z=-29174..-16871
on x=-24798..-1730,y=72778..96749,z=7809..19201
on x=-23651..-9598,y=-57234..-34582,z=-70338..-60811
off x=-62738..-27200,y=9928..29860,z=-82061..-55735
off x=-35621..-8459,y=71584..77639,z=-24783..543
on x=5884..24918,y=4508..27365,z=-79957..-56399
off x=50195..64289,y=48376..65137,z=-21184..896
off x=24188..59760,y=-44337..-27583,z=42362..66284
off x=-57347..-28736,y=-60601..-44136,z=-63070..-43716
off x=48377..66842,y=5381..28487,z=-56713..-36405
off x=-30632..-10325,y=-68112..-57776,z=-70249..-44986
on x=-27258..-24687,y=-27831..179,z=67481..80119
off x=25197..36490,y=58147..79063,z=-55819..-29388
on x=-42369..-14014,y=35824..40212,z=49626..67639
on x=72482..78811,y=2743..24960,z=-21034..9641
on x=-38737..-16444,y=-19459..-7136,z=70522..89734
off x=-47053..-18446,y=-49781..-27644,z=-63382..-45445
on x=-61779..-53562,y=-68401..-43173,z=-26499..2615
on x=70280..90492,y=-22017..-1048,z=-11788..9915
on x=16973..40998,y=55375..78623,z=5729..32627
on x=6679..29613,y=46958..81428,z=27700..55392
off x=-54278..-31989,y=37760..65264,z=47082..48144
on x=-24395..-1817,y=-3077..6849,z=62195..88101
off x=32931..47933,y=-80935..-47905,z=12414..35416
on x=-4833..29094,y=-74517..-46510,z=-50662..-36261
off x=17745..39300,y=-77063..-52076,z=14430..34896
on x=-4254..2793,y=-27799..-2199,z=61332..85652
on x=-11125..-6797,y=-67626..-59797,z=45783..53770
on x=-51997..-22683,y=-75871..-59016,z=-35612..-29371
off x=-53070..-30804,y=-37612..-16817,z=-61098..-33579
on x=-52249..-27676,y=65019..73794,z=8944..31489
on x=54561..70311,y=8710..27762,z=-60193..-29447
on x=-79526..-54134,y=-48561..-39181,z=12782..46387
off x=19885..33599,y=62071..83093,z=-50279..-13755
on x=23245..46830,y=20494..44306,z=-73620..-54933
on x=-79449..-67759,y=-24475..-10791,z=5687..32934
off x=-30071..-21031,y=54871..72346,z=32042..55267
off x=-30238..-2898,y=-77564..-51143,z=35341..64987
off x=54103..57884,y=36694..60345,z=-45985..-16112
on x=52740..71478,y=15648..46995,z=9255..41940
off x=47709..56624,y=42824..76404,z=-16692..-4361
off x=-79808..-65764,y=11636..14621,z=6874..40024
off x=-53031..-20679,y=-63906..-40440,z=24661..46608
off x=21238..38683,y=-78416..-46878,z=-47880..-35504
on x=-53581..-36276,y=-1941..20566,z=-71887..-54358
off x=-32154..-11432,y=-79738..-67958,z=-10706..17360
off x=10696..21438,y=-53803..-22129,z=-87224..-56070
off x=28285..52461,y=-49037..-26856,z=36499..53886
on x=-260..5955,y=24586..37153,z=-83960..-67924
off x=-50570..-23890,y=-75797..-57497,z=-41895..-29533
off x=-4478..14154,y=25690..41167,z=-78169..-65042
off x=53823..62681,y=-65274..-48164,z=11640..36739
off x=7445..17160,y=3112..20438,z=-79277..-66317
off x=-72283..-62851,y=-18551..17812,z=26518..45970
off x=-59435..-35677,y=-61145..-49053,z=-28620..-19260
on x=52909..71776,y=-35904..-8679,z=-45640..-18257
on x=-28198..-10547,y=47520..75387,z=-56238..-36602
on x=-78021..-57108,y=-202..20511,z=22910..26211
on x=6366..17660,y=-81206..-59720,z=-20739..4299
off x=62320..70434,y=-46472..-33338,z=24434..41197
on x=65053..71471,y=16283..27975,z=-53360..-32879
on x=25858..60433,y=-26017..-21914,z=48513..63801
off x=-79152..-68671,y=22088..30479,z=-22648..-10494
off x=67085..79404,y=-9147..17587,z=-34597..-22908
on x=-25433..-14453,y=-65170..-45979,z=46473..59725
on x=-85030..-67943,y=-43295..-20298,z=-28190..-8337
off x=14793..29071,y=51299..70682,z=-63333..-48581
on x=-22738..-3843,y=62665..91255,z=-40441..-6764
off x=-69466..-51782,y=-28726..-4741,z=51052..65722
off x=-37894..-19524,y=-83016..-54967,z=-15269..4234
off x=-51737..-36058,y=49755..52567,z=40935..52695
on x=5160..16270,y=-63557..-29172,z=-66325..-60455
on x=-12754..14999,y=42410..57660,z=-81237..-44235
off x=-21896..-1639,y=-6683..12111,z=-86947..-66486
on x=17671..34865,y=25801..50054,z=-69110..-52941
off x=53780..79949,y=-19080..-1582,z=-51267..-26442
on x=11705..31955,y=-18273..10873,z=-79513..-72321
off x=42225..64739,y=-63751..-38399,z=-21976..3241
on x=-83556..-68733,y=-27434..-7743,z=-13017..9177
on x=56237..76149,y=-34497..-16008,z=-39077..-19458
on x=-43305..-25014,y=-73343..-49996,z=-7825..-3892
on x=-64308..-43967,y=-33788..-28512,z=52866..68806
on x=-70700..-50756,y=31972..50876,z=-38908..-15838
off x=-57164..-42932,y=19342..48612,z=33732..55624
on x=-36748..-10589,y=51955..83318,z=-48442..-26669
on x=25359..40927,y=-79085..-59846,z=8036..36888
off x=10380..14539,y=71572..87896,z=-24628..-4781
off x=-47176..-28461,y=65456..67163,z=-40894..-16836
off x=-18332..8399,y=47821..71986,z=26668..47522
on x=-20965..-9481,y=-20308..4897,z=-95419..-57801
off x=31539..51751,y=35462..53163,z=-57494..-42838
off x=-18472..1572,y=75988..93471,z=-26864..1039
on x=-70785..-33731,y=-73997..-43660,z=-23224..9946
on x=19380..37078,y=53776..78064,z=-31936..-10509
on x=-8062..-2825,y=-82342..-69826,z=-13266..3969
off x=10179..29342,y=31007..48598,z=64959..69127
off x=-60805..-32266,y=43431..69404,z=8577..28595
off x=-22720..-3203,y=60404..66611,z=34857..59638
off x=-53582..-38618,y=52017..73240,z=27473..42769
off x=-72814..-66689,y=-45388..-21812,z=-14516..3856
on x=-73641..-69708,y=-15500..7339,z=-39764..-29382
off x=-4677..17044,y=-91970..-68336,z=-5685..15742
on x=11739..24073,y=35242..45244,z=-80024..-60736
on x=64670..76998,y=26199..39053,z=-15372..11264
on x=32930..62408,y=7820..14870,z=-84786..-50274
off x=1793..28795,y=19984..43135,z=67050..87662
on x=62730..81556,y=-59681..-32462,z=-9119..17314
off x=51211..84860,y=-10649..27833,z=33629..61327
on x=4877..24218,y=58754..64225,z=-51294..-29252
on x=-34998..-23262,y=-7791..15688,z=-77251..-73653
on x=-8985..2565,y=-80674..-57237,z=31372..66054
on x=26910..46858,y=-70174..-50719,z=-39433..-6303
on x=-77313..-45494,y=-35534..-19783,z=-56939..-23493
off x=-86093..-58555,y=-10764..-7163,z=32984..39939
off x=22629..45516,y=56413..69690,z=23879..45264
off x=6426..22257,y=-81295..-58682,z=-4833..30396
on x=-20499..-623,y=68725..85089,z=-3165..16088
on x=-22113..-8769,y=50723..69731,z=35423..63761
off x=17927..28889,y=66820..87168,z=7146..17344
on x=-51150..-32434,y=4434..29601,z=-87179..-50635
on x=44312..65806,y=-17376..-4824,z=-60807..-46664
off x=-74021..-63274,y=18155..23737,z=23087..44175
on x=53142..78645,y=11091..24149,z=-33898..-15733
on x=-89734..-59095,y=5415..39645,z=-30819..-14415
off x=-3526..9687,y=44579..60215,z=-61672..-41733
off x=73321..97678,y=7224..33092,z=-23526..-6480
on x=-38319..-18652,y=-94091..-57143,z=-27008..-10399
off x=-39624..-25656,y=-27151..-17149,z=62826..73496
off x=11777..31489,y=27498..41343,z=-66823..-64400
off x=-86379..-57406,y=1305..22612,z=-19292..-12364
off x=46778..72347,y=-30615..-14497,z=-57631..-38999
off x=11620..35158,y=60858..89766,z=3059..17854
off x=12508..29190,y=-69508..-58455,z=23048..41891
on x=-18252..13098,y=36042..44460,z=50978..82816
on x=-6496..13599,y=-32852..-21957,z=70926..82031
on x=69343..93866,y=-13495..12902,z=20150..37520
on x=14399..46141,y=-16440..-4786,z=64520..82073
on x=34907..49197,y=-77417..-58364,z=7116..41283
off x=-964..13645,y=-84374..-61091,z=5528..26680
on x=17413..51768,y=18101..39773,z=59112..72097
on x=-66173..-34985,y=-64364..-26681,z=-46312..-32514
on x=4907..25817,y=-86293..-63574,z=20626..51969
off x=25870..59523,y=34211..49946,z=40232..74133
off x=-54230..-38453,y=30481..43869,z=-54591..-40302
on x=-19584..11278,y=-61815..-44911,z=-59169..-54278
off x=9524..37706,y=69604..90591,z=2047..19112
off x=-55707..-36536,y=32805..48941,z=-69826..-44814
off x=-47397..-26251,y=-45541..-17561,z=51498..63966
on x=-26274..-8974,y=-11082..14341,z=-95770..-63704
on x=63227..82757,y=-53349..-33869,z=6276..38367
off x=-9009..17116,y=-1685..15956,z=-89391..-75291
off x=-60467..-32934,y=-16532..8638,z=66520..73970
on x=42282..63814,y=-52404..-29292,z=16300..39083
on x=59807..76726,y=-59577..-30112,z=-6617..22740
off x=-71581..-61332,y=-11793..7729,z=28377..51215
off x=58949..86888,y=-38405..-857,z=-27434..-1959
on x=-38039..-18664,y=-52842..-30904,z=-69197..-39328
on x=34271..60705,y=-13427..9155,z=-86631..-62294
on x=-47181..-37507,y=52951..66180,z=31932..41322
on x=50153..80932,y=-4041..16916,z=32832..52829
on x=-5561..25588,y=-10476..10520,z=78611..97383
off x=-83214..-60530,y=-3562..17310,z=7405..28737
on x=-60777..-54134,y=54086..73346,z=-11397..12806
on x=8008..14420,y=-63596..-41593,z=-68526..-45673
off x=24007..49083,y=-16462..-7045,z=57536..81481
off x=-11681..3645,y=-58012..-41953,z=55142..76200
off x=-76656..-52954,y=35846..55582,z=-53872..-34722
on x=-12038..8659,y=-87346..-69918,z=28070..47940
on x=-11947..10184,y=-53409..-34027,z=-72583..-47438
off x=-55067..-35621,y=-69939..-60505,z=-14835..1042
off x=32935..37139,y=-85226..-70552,z=-25685..4412
on x=-28948..-4652,y=36671..63289,z=-68708..-50580
off x=11959..12834,y=37735..57272,z=-76650..-51945
off x=-80869..-62027,y=-29135..1722,z=-41049..-20272
off x=-16105..-9908,y=13813..43802,z=-91236..-73026
on x=-49560..-40469,y=43630..61941,z=-52839..-35457
off x=9147..25541,y=-80287..-59670,z=42741..55735
off x=50379..79472,y=29160..49483,z=-5978..29107
on x=-88412..-58603,y=-3423..3159,z=19531..41416
off x=-1015..23656,y=53461..84876,z=27264..47816
off x=-34955..-31932,y=56566..75983,z=-11994..10763
off x=-33477..-1860,y=19104..24306,z=-77651..-71897
on x=-73047..-48583,y=28931..56704,z=23154..30012
off x=70083..72794,y=-5597..15786,z=-51791..-23271
on x=28989..57370,y=40583..60178,z=-62971..-45863
on x=55125..91706,y=-15559..4561,z=15786..49181
off x=-24690..-3730,y=59694..97039,z=724..22523
on x=50442..59532,y=-34136..-13939,z=-73167..-41283
on x=-42457..-22829,y=28486..55735,z=-61093..-54803
off x=59374..88933,y=-35520..-16575,z=21065..24982
off x=47891..77004,y=-55581..-33892,z=-24958..-20207
on x=-39381..-6103,y=25106..44027,z=51236..84981
off x=53027..72033,y=-66349..-40215,z=-1886..6465
off x=-16688..3581,y=-13126..2347,z=-92211..-65235
on x=-42613..-26870,y=-29924..-12291,z=-67035..-61494
off x=63092..79122,y=988..21133,z=-16953..3867
off x=-67216..-58011,y=-53495..-33034,z=-11608..-1856
off x=53934..86965,y=-44444..-9436,z=16273..30447
off x=-4034..19635,y=-54143..-37719,z=-78365..-41039
on x=-34211..-14894,y=-25413..-719,z=56386..88338
on x=-57326..-35994,y=-38049..-8173,z=-56649..-54035
off x=30271..50936,y=-87052..-56522,z=3300..32145
on x=55833..75804,y=18495..43321,z=-27127..-11497"""



inputSplit = input.split("\n")

import math
import numpy as np
import re

class FloatRange:
    """Using this because I started with range(a, b) but this 
    constructor doesn't accept float arguments - so to avoid 
    re-writing lots of code I just created a new simple class"""
    def __init__(self, start, stop):
        self.start = start
        self.stop = stop


def median(a, b, c):
    return sorted([a, b, c])[1]


def between(value, start, end):
    return start <= value and value <= end


class Cube:    
    """Representation of a cube. Given input coordinates of the corners
    of the cube, we hold a representation which is larger than the actual cube
    by 0.5 on all sides. This allows for us to manage the slithers which sit
    between cubes separately - i.e. where two cubes align on a line, we need
    a way to tell for the line of intersection, whether the values on that
    face are on or off.    
    """
    def __init__(self, inputString = None):
        if inputString is not None:
            groupRegex = "(on|off) x=(-{0,1}[\d]+)\.\.(-{0,1}[\d]+),y=(-{0,1}[\d]+)\.\.(-{0,1}[\d]+),z=(-{0,1}[\d]+)\.\.(-{0,1}[\d]+)"
            
            state, xStart, xEnd, yStart, yEnd, zStart, zEnd = re.match(groupRegex, inputString).groups()
            
            self.xrange = FloatRange(int(xStart) - 0.5, int(xEnd) + 0.5)
            self.yrange = FloatRange(int(yStart) - 0.5, int(yEnd) + 0.5)
            self.zrange = FloatRange(int(zStart) - 0.5, int(zEnd) + 0.5)
            self.state = state
    
    def build(xStart, xEnd, yStart, yEnd, zStart, zEnd, state):
        thisCube = Cube()
        thisCube.xrange = FloatRange(xStart, xEnd)
        thisCube.yrange = FloatRange(yStart, yEnd)
        thisCube.zrange = FloatRange(zStart, zEnd)
        thisCube.state = state
        return thisCube        
        
    def _intersect(self, rangeA, rangeB):        
        aStart, aEnd = rangeA.start, rangeA.stop
        bStart, bEnd = rangeB.start, rangeB.stop
        
        return (aStart <= bStart and bStart <= aEnd) or (bStart <= aStart and aStart <= bEnd)
    
    def intersects(self, otherCube):        
        if not self._intersect(self.xrange, otherCube.xrange):
            return False
        elif not self._intersect(self.yrange, otherCube.yrange):
            return False
        elif not self._intersect(self.zrange, otherCube.zrange):
            return False
        else:
            return True
        
    def contains(self, otherCube):
        return (between(otherCube.xrange.start, self.xrange.start, self.xrange.stop) and 
                between(otherCube.xrange.stop, self.xrange.start, self.xrange.stop) and                
               
                between(otherCube.yrange.start, self.yrange.start, self.yrange.stop) and 
                between(otherCube.yrange.stop, self.yrange.start, self.yrange.stop) and                
               
                between(otherCube.zrange.start, self.zrange.start, self.zrange.stop) and 
                between(otherCube.zrange.stop, self.zrange.start, self.zrange.stop))
        
    def iterator(self, zoneSize):
        testCube = Cube.build(-zoneSize, zoneSize, -zoneSize, zoneSize, -zoneSize, zoneSize, "unused")        
        
        if self.intersects(testCube):
            xStart, xEnd = math.ceil(self.xrange.start), math.floor(self.xrange.stop)
            yStart, yEnd = math.ceil(self.yrange.start), math.floor(self.yrange.stop)
            zStart, zEnd = math.ceil(self.zrange.start), math.floor(self.zrange.stop)
            
            xAdjStart, xAdjEnd = median(-zoneSize, zoneSize, xStart), median(-zoneSize, zoneSize, xEnd)
            yAdjStart, yAdjEnd = median(-zoneSize, zoneSize, yStart), median(-zoneSize, zoneSize, yEnd)
            zAdjStart, zAdjEnd = median(-zoneSize, zoneSize, zStart), median(-zoneSize, zoneSize, zEnd)
            
            return [(x, y, z) 
                    for x in range(xAdjStart, xAdjEnd + 1) 
                    for y in range(yAdjStart, yAdjEnd + 1)
                    for z in range(zAdjStart, zAdjEnd + 1)]
        else:
            return []        
        
    def gridCount(self):
        xStart, xEnd = math.ceil(self.xrange.start), math.floor(self.xrange.stop)
        yStart, yEnd = math.ceil(self.yrange.start), math.floor(self.yrange.stop)
        zStart, zEnd = math.ceil(self.zrange.start), math.floor(self.zrange.stop)
        return (xEnd - xStart + 1) * (yEnd - yStart + 1) * (zEnd - zStart + 1)
        
    def gridCountInZone(self, zoneSize):
        xStart, xEnd = math.ceil(self.xrange.start), math.floor(self.xrange.stop)
        yStart, yEnd = math.ceil(self.yrange.start), math.floor(self.yrange.stop)
        zStart, zEnd = math.ceil(self.zrange.start), math.floor(self.zrange.stop)
        
        xAdjStart, xAdjEnd = median(-zoneSize, zoneSize, xStart), median(-zoneSize, zoneSize, xEnd)
        yAdjStart, yAdjEnd = median(-zoneSize, zoneSize, yStart), median(-zoneSize, zoneSize, yEnd)
        zAdjStart, zAdjEnd = median(-zoneSize, zoneSize, zStart), median(-zoneSize, zoneSize, zEnd)
        
        return (xAdjEnd - xAdjStart + 1) * (yAdjEnd - yAdjStart + 1) * (zAdjEnd - zAdjStart + 1)
        
    def __repr__(self):
        return f"state: {self.state} x:({self.xrange.start}, {self.xrange.stop}) y:({self.yrange.start}, {self.yrange.stop}) z:({self.zrange.start}, {self.zrange.stop})"
        

largeCubes = []
for line in inputSplit:
    largeCubes.append(Cube(line))

# Strategy for remainder of puzzle:
# Consider a large cube which contains all cubes. Split that cube into
# multiple smaller disjoint cubes from which any of the original cubes
# can be created - i.e. by joining together several smaller cubes.
# In order to generate this space, first consider one dimension (e.g. x).
# Look at all points where there's a potential split in the x dimension.
# For example, if in 2D the squares were (-1, 4)x(3, 5) and (2, 9)x(4, 10)
# there would be splits at -1, 2, 3, and 4. 
# After you've generates the splits, work through each split (i.e. (-1, 2),
# (2, 3), (3, 4)). For each split you can work out which cubes have any overlap
# with that split. Using this subset of cubes, you can work out which y
# and z splits exist. Chop up the x-split into y*z cubes, and then filter 
# only keeping those cubes which have some intersection with the large list
# of cubes.
# While doing this, maintain two dictionaries - one which points from small cubes
# to large cubes, and one which points from large cubes to small cubes.


def filterCubesX(cubeList, xStart, xEnd):    
    filteredCubes = []
    for cube in cubeList:
        if xEnd <= cube.xrange.start or cube.xrange.stop <= xStart:
            continue
        else:            
            filteredCubes.append(cube)

    return filteredCubes


def filterCubesY(cubeList, yStart, yEnd):    
    filteredCubes = []
    for cube in cubeList:
        if yEnd <= cube.yrange.start or cube.yrange.stop <= yStart:
            continue
        else:            
            filteredCubes.append(cube)

    return filteredCubes


# A list of all small cubes which are included in any cube
smallCubes = []
smallCubeCount = 0
# For each large cube a list of the indexes in the smallCubeList which correspond
# with cubes which make up the larger cube.
largeCubeToSmallCube = {largeCube : [] for largeCube in largeCubes}

xSplitPoints = set()
for cube in largeCubes:
    xSplitPoints.add(cube.xrange.start)
    xSplitPoints.add(cube.xrange.stop)

xSplitPoints = sorted(list(xSplitPoints))

xSplitCount = len(xSplitPoints) - 1
for i_x in range(xSplitCount):
    xSplitStart, xSplitEnd = xSplitPoints[i_x], xSplitPoints[i_x + 1]    
    
    intersectingCubesX = filterCubesX(largeCubes, xSplitStart, xSplitEnd)
    
    ySplitPoints = set()    
    for cube in intersectingCubesX:
        ySplitPoints.add(cube.yrange.start)
        ySplitPoints.add(cube.yrange.stop)        
        
    ySplitPointsSorted = sorted(list(ySplitPoints))
    ySplitCount = len(ySplitPointsSorted) - 1    
    
    for i_y in range(ySplitCount):
        ySplitStart, ySplitEnd = ySplitPointsSorted[i_y], ySplitPointsSorted[i_y + 1]
    
        intersectingCubesY = filterCubesY(intersectingCubesX, ySplitStart, ySplitEnd)
            
        zSplitPoints = set()
        for cube in intersectingCubesY:            
            zSplitPoints.add(cube.zrange.start)
            zSplitPoints.add(cube.zrange.stop)
    
        zSplitPointsSorted = sorted(list(zSplitPoints))
        zSplitCount = len(zSplitPointsSorted) - 1
    
        for i_z in range(zSplitCount):
            zSplitStart, zSplitEnd = zSplitPointsSorted[i_z], zSplitPointsSorted[i_z + 1]
            
            smallCube = Cube.build(xSplitStart, xSplitEnd, ySplitStart, ySplitEnd, zSplitStart, zSplitEnd, "unused")

            intersectsLargeCubes = False

            for cube in intersectingCubesY:
                if cube.contains(smallCube):
                    intersectsLargeCubes = True
                    largeCubeToSmallCube[cube].append(smallCubeCount)                    
            
            if intersectsLargeCubes:
                smallCubes.append(smallCube)
                smallCubeCount += 1


# Run Reboot Steps
smallCubeOnOffList = np.full(smallCubeCount, "off")

i = 0
for largeCube in largeCubes:    
    i += 1
    thisState = largeCube.state
    
    for smallCubeId in largeCubeToSmallCube[largeCube]:
        smallCubeOnOffList[smallCubeId] = thisState
            
# Part 1 - need to only consider cubes which are in the 50x50x50 zone.

part1Cube = Cube.build(-50, 50, -50, 50, -50, 50, "Part 1")

part1SmallCubes = []

for id_cube in range(smallCubeCount):
    if smallCubeOnOffList[id_cube] == "on":
        if smallCubes[id_cube].intersects(part1Cube):
            part1SmallCubes.append(id_cube)
        
part1Cubes = [smallCubes[id] for id in part1SmallCubes]

onCount = 0

uniqueXYSet = set()

for id in part1SmallCubes:
    thisCube = smallCubes[id]
    onCount += thisCube.gridCountInZone(50)
    uniqueXYSet.add(((thisCube.xrange.start, thisCube.xrange.stop), 
                     (thisCube.yrange.start, thisCube.yrange.stop)
                     ))

fullCount = 0
for id in range(smallCubeCount):
    if smallCubeOnOffList[id] == "on":
        fullCount += smallCubes[id].gridCount()

# part1Lazy
onCells = set()
i = 0
for cube in largeCubes:
    print(f"{i} {len(onCells)}")    
    i += 1
    for coord in cube.iterator(50):
        if cube.state == "on":
            onCells.add(coord)
        else:
            onCells.discard(coord)
