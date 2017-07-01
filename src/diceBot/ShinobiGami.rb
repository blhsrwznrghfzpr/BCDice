# -*- coding: utf-8 -*-

class ShinobiGami < DiceBot
  setPrefixes(['ST', 'FT', 'ET', 'WT', 'BT', 'CST', 'MST', 'IST','EST','DST','TST', 'NST', 'KST', 'TKST', 'GST', 'GWT', 'GAST', 'KYST', 'JBST', 'KFT', 'KWT', 'MT', 'RTT'])

  def initialize
    super
    @sendMode = 2
    @sortType = 1
    @d66Type = 2
  end

  def gameName
    'シノビガミ'
  end

  def gameType
    "ShinobiGami"
  end

  def getHelpMessage
    return <<INFO_MESSAGE_TEXT
・各種表
　・(無印)シーン表　ST／ファンブル表　FT／感情表　ET
　　　／変調表　WT／戦場表　BT／異形表　MT／ランダム特技決定表　RTT
　・(弐)都市シーン表　CST／館シーン表　　MST／出島シーン表　DST
　・(参)トラブルシーン表　TST／日常シーン表　NST／回想シーン表　KST
　・(死)東京シーン表　TKST／戦国シーン表　GST
　・(乱)戦国変調表　GWT
　・(リプレイ戦1〜2巻)学校シーン表　GAST／京都シーン表　KYST
　　　／神社仏閣シーン表　JBST
　・(怪)怪ファンブル表　KFT／怪変調表　KWT
　・（その他）秋空に雪舞えばシーン表　AKST／災厄シーン表　CLST
　　／出島EXシーン表　DXST／斜歯ラボシーン表　HLST
　　／夏の終わりシーン表　NTST／培養プラントシーン表　　PLST
　　・忍秘伝　　中忍試験シーン表　HC/滅びの塔シーン表　HT/影の街でシーン表　HK
　　/夜行列車シーン表　HY/病院シーン表　HO/龍動シーン表　HR/密室シーン表　HM/催眠シーン表　HS
・D66ダイスあり
INFO_MESSAGE_TEXT
  end

  def check_2D6(total_n, dice_n, signOfInequality, diff, dice_cnt, dice_max, n1, n_max)  # ゲーム別成功度判定(2D6)
    return '' unless( signOfInequality == ">=")

    if(dice_n <= 2)
      return " ＞ ファンブル"
    elsif(dice_n >= 12)
      return " ＞ スペシャル(生命点1点か変調1つ回復)"
    elsif(total_n >= diff)
      return " ＞ 成功"
    else
      return " ＞ 失敗"
    end
  end

  def rollDiceCommand(command)
    string = command.upcase

    case string
    when /((\w)*ST)/i   # シーン表
      return sinobigami_scene_table(string)
    when /([K]*FT)/i   # ファンブル表
      return sinobigami_fumble_table(string)
    when /(ET)/i   # 感情表
      return sinobigami_emotion_table()
    when /([GK]?WT)/i   # 変調表
      return sinobigami_wrong_table(string)
    when /(BT)/i   # 戦場表
      return sinobigami_battlefield_table()
    when /((\w)*RTT)/i   # ランダム特技決定表
      return sinobigami_random_skill_table()
    when /(MT)/i   # 異形表
      return sinobigami_metamorphose_table()
    end

    return nil
  end

  # シーン表
  def sinobigami_scene_table(string)
    type = ""
    table = []

    case string
    when /CST/i
      type = '都市'
      table = [
               'シャワーを浴び、浴槽に疲れた身体を沈める。時には、癒しも必要だ。',
               '閑静な住宅街。忍びの世とは関係のない日常が広がっているようにも見えるが……それも錯覚なのかもしれない',
               '橋の上にたたずむ。川の対岸を結ぶ境界点。さて、どちらに行くべきか……？',
               '人気のない公園。野良猫が一匹、遠くからあなたを見つめているような気がする。',
               '至福の一杯。この一杯のために生きている……って、いつも言ってるような気がするなぁ。',
               '無機質な感じのするオフィスビル。それは、まるで都市の墓標のようだ。',
               '古びた劇場。照明は落ち、あなたたちのほかに観客の姿は見えないが……。',
               '商店街を歩く。人ごみに混じって、不穏な気配もちらほら感じるが……。',
               'ビルの谷間を飛び移る。この街のどこかに、「アレ」は存在するはずなのだが……。',
               '見知らぬ天井。いつの間にか眠っていたのだろうか？それにしてもここはどこだ？',
               '廃屋。床には乱雑に壊れた調度品や器具が転がっている。',
              ]
    when /MST/i
      type = '館'
      table = [
               'どことも知れぬ暗闇の中。忍びの者たちが潜むには、おあつらえ向きの場所である。',
               '洋館の屋根の上。ここからなら、館の周りを一望できるが……。',
               '美しい庭園。丹精こめて育てられたであろう色とりどりの花。そして、綺麗に刈り込まれた生垣が広がっている。',
               'あなたは階段でふと足を止めた。何者かの足音が近づいているようだ。',
               'あなたに割り当てられた寝室。ベッドは柔らかく、調度品も高級なものばかりだが……。',
               'エントランスホール。古い柱時計の時報が響く中、館の主の肖像画が、あなたを見下ろしている。',
               '食堂。染み一つないテーブルクロスに覆われた長い食卓。その上は年代物の燭台や花で飾られている。',
               '長い廊下の途中。この屋敷は広すぎて、迷子になってしまいそうだ。',
               '戯れに遊戯室へ入ってみた。そこには撞球台やダーツの的、何組かのトランプが散らばっているポーカーテーブルがあった。',
               'かび臭い図書室。歴代の館の主たちの記録や、古今東西の名著が、ぎっしりと棚に並べられている。',
               '一族の納骨堂がある。冷気と瘴気に満ちたその場所に、奇妙な叫びが届く。遠くの鳥のさえずりか？それとも死者の恨みの声か……？',
              ]
    when /DST/i
      type = '出島'
      table = [
               '迷宮街。いつから囚われてしまったのだろう？何重にも交差し、曲がりくねった道を歩き続ける。このシーンの登場人物は《記憶術》で判定を行わなければならない。成功すると、迷宮の果てで好きな忍具を一つ獲得する。失敗すると、行方不明の変調を受ける。',
               '幻影城。訪れた者の過去や未来の風景を見せる場所。このシーンの登場人物は、《意気》の判定を行うことができる。成功すると、自分の持っている【感情】を好きな何かに変更することができる。',
               '死者たちの行進。無念の死を遂げた者たちが、仲間を求めて彷徨らっている。このシーンの登場人物は《死霊術》で判定を行わなければならない。失敗すると、ランダムに変調を一つを受ける。',
               'スラム。かろうじて生き延びている人たちが肩を寄せ合い生きているようだ。ここなら辛うじて安心できるかも……。',
               '落書きだらけのホテル。その周囲には肌を露出させた女や男たちが、媚態を浮かべながら立ち並んでいる。',
               '立ち並ぶ廃墟。その影から、人とも怪物ともつかぬ者の影が、あなたの様子をじっとうかがっている。',
               '薄汚い路地裏。巨大な黒犬が何かを貪っている。あなたの気配を感じて黒犬は去るが、そこに遺されていたのは……。',
               '昏い酒場。バーテンが無言でグラスを磨き続けている。あなたの他に客の気配はないが……。',
               '地面を覆う無数の瓦礫。その隙間から暗黒の瘴気が立ち昇る。このシーンの登場人物は《生存術》で判定を行わなければならない。失敗すると、好きな【生命力】を１点失う。',
               '熱気溢れる市場。武器や薬物などを売っているようだ。商人たちの中には、渡来人の姿もある。このシーンの登場人物は、《経済力》で判定を行うことができる。成功すると、好きな忍具を一つ獲得できる。',
               '目の前に渡来人が現れる。渡来人はあなたに興味を持ち、襲い掛かってくる。このシーンの登場人物は《刀術》で判定を行わなければならない。成功すると、渡来人を倒し、好きな忍具を一つ獲得する。失敗すると、３点の接近戦ダメージを受ける。',
              ]
    when /TST/i
      type = 'トラブル'
      table = [
               '同行者とケンカしてしまう。うーん、気まずい雰囲気。',
               'バシャ！　同行者のミスでずぶ濡れになってしまう。……冷たい。',
               '敵の気配に身を隠す。……すると、同行者の携帯が着信音を奏で始める。「……えへへへへ」じゃない！',
               '同行者の空気の読めない一言。場が盛大に凍り付く。まずい。何とかしないと。',
               '危機一髪！　同行者を死神の魔手から救い出す。……ここも油断できないな。',
               '同行者が行方不明になる。アイツめ、どこへ逃げたッ！',
               'ずて────ん！　あいたたたた……同行者がつまずいたせいで、巻き込まれて転んでしまった。',
               '同行者のせいで、迷子になってしまう。困った。どこへ行くべきか。',
               '「どこに目つけてんだ、てめぇ！」同行者がチンピラにからまれる。うーん、助けに入るべきか。',
               '！　油断していたら、同行者に自分の恥ずかしい姿を見られてしまう。……一生の不覚！',
               '同行者が不意に涙を流す。……一体、どうしたんだろう？',
              ]
    when /NST/i
      type = '日常'
      table = [
               'っくしゅん！　……うーん、風邪ひいたかなあ。お見舞いに来てくれたんだ。ありがとう。',
               '目の前のアイツは、見違えるほどドレスアップしていた。……ゆっくりと大人な時間が過ぎていく。',
               'おいしそうなスイーツを食べることになる。たまには甘いものを食べて息抜き息抜き♪',
               'ふわわわわ、いつの間にか寝ていたようだ。……って、あれ？　お前、いつからそこにいたッ!!',
               '買い物帰りの友人と出会う。方向が同じなので、しばらく一緒に歩いていると、思わず会話が盛り上がる。',
               'コンビニ。商品に手を伸ばしたら、同時にその商品をとろうとした別の人物と手が触れあう。なんという偶然！',
               'みんなで食卓を囲むことになる。鍋にしようか？　それとも焼き肉？　お好み焼きなんかもい〜な〜♪',
               'どこからか楽しそうな歌声が聞こえてくる。……って、あれ？　何でお前がこんなところに？',
               '野良猫に餌をやる。……猫はのどを鳴らし、すっかりあなたに甘えているようだ。',
               '「……！　……？　……♪」テレビは、なにやら楽しげな場面を映している。あら。もう、こんな時間か。',
               '面白そうなゲーム！　誰かと対戦することになる。GMは、「戦術」からランダムに特技1つを選ぶ。このシーンに登場しているキャラクターは、その特技の判定を行う。成功した場合、同じシーンに登場しているキャラクターを1人を選び、そのキャラクターの自分に対する【感情】を好きなものに変更する（何の【感情】も持っていない場合、好きな【感情】を芽生えさせる）。',
              ]
    when /TKST/i
      type = '東京'
      table = [
               'お台場、臨界副都心。デート中のカップルや観光客が溢れている。',
               '靖国神社。東京の中とも思えぬ、緑で満ちた場所だ。今は観光客もおらず、奇妙に静かだ……。',
               '東京大学の本部キャンパス。正門から伸びる銀杏並木の道を学生や教職員がのんびりと歩いている。道の向こうには安田講堂が見える。',
               '山手線の中。乗車率200％を超える、殺人的な通勤ラッシュ真っ最中。この中でできることは限られている……。',
               '霞が関。この場に集う情報は、忍者にとっても価値が高いものだ。道を行く人々の中にも、役人や警察官が目につく。',
               '渋谷駅前の雑踏。大型屋外ヴィジョンが見下ろす中で、大勢の若者たちが行き交っている。',
               '夜の新宿歌舞伎町。酔っぱらったサラリーマン、華やかな夜の蝶、明らかに筋ものと判る男、外国人などの様々な人間と、どこか危険な雰囲気に満ちている。',
               '新宿都庁。摩天楼が林立するビル街の下、背広姿の人々が行き交う。',
               '神田古書街。多くの古書店が軒を連ねている。軒先に積まれた本の山にさえ、追い求める謎や、深遠な知識が埋もれていそうな気がする。',
               '山谷のドヤ街。日雇い労働者が集う管理宿泊施設の多いこの場所は、身を隠すにはうってつけだ。',
               '東京スカイツリーの上。この場所からならば東京の町が一望できる。',
              ]
    when /KST/i
      type = '回想'
      table = [
               '闇に蔓延する忍びの気配。あのときもそうだった。手痛い失敗の記憶。今度こそ、うまくやってみせる。',
               '甘い口づけ。激しい抱擁。悲しげな瞳……一夜の過ちが思い返される。',
               '記憶の中でゆらめくセピア色の風景。……見覚えがある。そう、私はここに来たことがあるはずだッ!!',
               '目の前に横たわる死体。地面に広がっていく。あれは、私のせいだったのだろうか……？',
               'アイツとの大切な約束を思い出す。守るべきだった約束。果たせなかった約束。',
               '助けを求める右手が、あなたに向かってまっすぐ伸びる。あなたは、必死でその手を掴もうとするが、あと一歩のところで、その手を掴み損ねる……。',
               'きらきらと輝く笑顔。今はもう喪ってしまった、大事だったアイツの笑顔。',
               '恐るべき一撃！　もう少しで命を落とすところだった……。しかし、あの技はいまだ見切れていない。',
               '幼い頃の記憶。仲の良かったあの子。そういえば、あの子は、どこに行ってしまったのだろう。もしかして……。',
               '「……ッ!!」激しい口論。ひどい別れ方をしてしまった。あんなことになると分かっていたら……。',
               '懐の中のお守りを握りしめる。アイツにもらった、大切な思い出の品。「兵糧丸」を1つ獲得する。',
              ]
    when /GST/i
      type = '戦国'
      table = [
               '炎上する山城。人々の悲鳴や怒号がこだましている。どうやら、敵対する武将による焼き討ちらしい。今ならば、あるいは……。',
               '荒れ果てた村。カラスの不吉な鳴き声が聞こえてくる中で、やせ細った村人たちが、うつろな瞳でこちらを伺っている。',
               '人気のない山道。ただ鳥の声だけが響いている。通りがかった人を襲うのには、好都合かもしれない。',
               '乾いた骸の転がる合戦後。生き物の姿はなく、草の一本さえも生えていない。落ち武者たちの恨みがましい声が聞こえてきそうだ……。',
               '不気味な気配漂う森の中。何か得体のしれぬものが潜んでいそうだ。',
               '荒れ果てた廃寺。ネズミがカサカサと這いまわる本堂の中を、残された本尊が見下ろしている。',
               '街道沿いの宿場町。戦から逃げてきたらしい町人や、商売の種を探す商人、目つきの鋭い武士などが行き交い、賑わっている。',
               '城の天守閣のさらに上。強く吹く風が、雲を流していく。',
               '館の天井裏。この下では今、何が行われているのか……。',
               '合戦場に設けられた陣内。かがり火がたかれ、武者たちが酒宴を行っている。',
               '戦の真っただ中にある合戦場。騎馬にまたがった鎧武者が駆け抜けていく。勝者となるのは、いずれの陣営だろうか。',
              ]
    when /GAST/i
      type = '学校'
      table = [
               '清廉な気配が漂う森の中。鳥のさえずりやそよ風が木々を通りすぎる音が聞こえる。',
               '学校のトイレ。……なんだか少しだけ怖い気がする。',
               '誰もいない体育館。バスケットボールがころころと転がっている。',
               '校舎の屋上。一陣の風が吹き、衣服をたなびかせる。',
               '校庭。体操服姿の生徒たちが走っている。',
               '廊下。休憩時間か放課後か。生徒たちが、楽しそうにはしゃいでいる。',
               '学食のカフェテリア。生徒たちがまばらに席につき、思い思い談笑している。',
               '静かな授業中の風景。しかし、忍術を使って一般生徒に気取られない会話をしている忍者たちもいる。',
               '校舎と校舎をつなぐ渡り廊下。あなた以外の気配はないが……。',
               '特別教室。音楽室や理科室にいるのってなんか楽しいよね。',
               'プール。水面が、ゆらゆら揺れている。',
              ]
    when /KYST/i
      type = '京都'
      table = [
               '夜の街並み。神社仏閣はライトアップされ、にぎやかな酔客が通りを埋める。昼間とはまた違った景色が広がっている。',
               '京都駅ビル。その屋上は、京都市で最も高く、周囲を一望できる。',
               '旅館で一休み。……のはずが、四方山話に花が咲く。',
               '鴨川のあたりを歩いている。カップルが均等に距離を置いて座っているのが面白い。',
               '京都はどこにでもおみやげ物屋があるなぁ。さて、あいつに何を買ってやるべきか……？',
               '「神社仏閣シーン表(JBST)」で決定。',
               '新京極でお買い物。アーケードには、新旧様々な店が建ち並ぶ。',
               '大学が近くにあるのかな？　安い定食屋や古本屋、ゲームセンターなどが軒を連ねる学生街。京都はたくさん大学があるなぁ。',
               '静かな竹林。凛とした気配が漂う。',
               '祇園。時折、しずしずと歩く舞妓さんとすれ違う。雰囲気のある町並みだ。',
               '一般公開された京都御所の中を歩く。昼間だというのに人通りはあまりなく、何だか少し寂しい気持ち。',
              ]
    when /JBST/i
      type = '神社仏閣'
      table = [
               '清明神社。一条戻り橋を越えたところにある小さな社。陰陽師に憧れる女性たちの姿が目立つ。',
               '東寺。東寺真言宗総本山。密教独特の厳しい気配が漂う。',
               '平安神宮。大鳥居を白無垢の花嫁行列がくぐり抜けていくのが見える。どうやら結婚式のようだ。',
               '慈照寺――通称、銀閣寺。室町後期の東山文化を代表する建築である。錦鏡池を囲む庭園には、物思いにふける観光客の姿が……。',
               '鹿苑寺――通称、金閣寺。室町前期の北山文化を代表する建築である。鏡湖池に映る逆さ金閣には、強力な「魔」を封印していると言うが……？',
               '三十三間堂。荘厳な本堂に立ち並ぶ千一体の千手観音像は圧巻。',
               '清水寺。清水坂を越え、仁王門を抜けると、本堂――いわゆる清水の舞台にたどり着く。そこからは、音羽の滝や子安塔が見える。',
               '八坂神社。祇園さんの名前で知られるにぎやかな神社。舞妓さんの姿もちらほら。',
               '伏見稲荷。全国約四万社の稲荷神社の総本宮。稲荷山に向かって立ち並ぶ約一万基の鳥居は、まるで異界へと続いているかのようだ……。',
               '化野念仏寺。無数の石塔、石仏が立ち並ぶ景色は、どこか荒涼としている……。',
               '六道珍皇寺。小野篁が冥界に通ったとされる井戸のある寺。この辺りは「六道の辻」と呼ばれ、不思議な伝説が数多く残っている。',
              ]

    else
      table = [
               '血の臭いがあたりに充満している。何者かの戦いがあった気配。　いや？まだ戦いは続いているのだろうか？',
               'これは……夢か？　もう終わったはずの過去。しかし、それを忘れることはできない。',
               '眼下に広がる街並みを眺める。ここからなら街を一望できるが……。',
               '世界の終わりのような暗黒。暗闇の中、お前達は密やかに囁く。',
               '優しい時間が過ぎていく。影の世界のことを忘れてしまいそうだ。',
               '清廉な気配が漂う森の中。鳥の囀りや、そよ風が樹々を通り過ぎる音が聞こえる。',
               '凄まじい人混み。喧噪。影の世界のことを知らない無邪気な人々の手柄話や無駄話が騒がしい。',
               '強い雨が降り出す。人々は、軒を求めて、大慌てて駆けだしていく。',
               '大きな風が吹き荒ぶ。髪の毛や衣服が大きく揺れる。何かが起こりそうな予感……',
               '酔っぱらいの怒号。客引きたちの呼び声。女たちの嬌声。いつもの繁華街の一幕だが。',
               '太陽の微笑みがあなたを包み込む。影の世界の住人には、あまりにまぶしすぎる。',
              ]

    end

    get_sinobigami_2d6_scene_table_output(type, table)
  end

  def get_sinobigami_2d6_scene_table_output(sceneType, table)
    total_n, = roll(2, 6)
    index = total_n - 2

    text = table[index]
    return '1' if( text.nil? )

    output = "#{sceneType}シーン表(#{total_n}) ＞ #{ text }"

    return output
  end

  def get_sinobigami_1d6_table_output(tableName, table)
    total_n, = roll(1, 6)
    index = total_n - 1

    text = table[index]
    return '1' if( text.nil? )

    output = "#{tableName}(#{total_n}) ＞ #{text}"

    return output

  end

  # ファンブル表
  def sinobigami_fumble_table(string)
    table = []
    type = ''

    case string
    when /KFT/
      type = '怪'
      table = [
               '何か調子がおかしい。そのサイクルの間、すべての行為判定にマイナス１の修正がつく。',
               'しまった！　好きな忍具を１つ失ってしまう。',
               '情報が漏れる！　あなた以外のキャラクターは、あなたの持っている【秘密】か【居所】の中から、好きなものをそれぞれ一つ知ることができる。',
               '油断した！　術の制御に失敗し、好きな【生命力】を１点失う。',
               '敵の陰謀か？　罠にかかり、ランダムに選んだ変調一つを受ける。変調は、変調表で決定すること。',
               'ふう。危ないところだった。特に何も起こらない。',
              ]
    else
      table = [
               '何か調子がおかしい。そのサイクルの間、すべての行為判定にマイナス１の修正がつく。',
               'しまった！　好きな忍具を１つ失ってしまう。',
               '情報が漏れる！　このゲームであなたが獲得した【秘密】は、他のキャラクター全員の知るところとなる。',
               '油断した！　術の制御に失敗し、好きな【生命力】を１点失う。',
               '敵の陰謀か？　罠にかかり、ランダムに選んだ変調１つを受ける。変調は、変調表で決定すること。',
               'ふう。危ないところだった。特に何も起こらない。',
              ]
    end

    return get_sinobigami_1d6_table_output("#{type}ファンブル表", table)
  end

  # 感情表
  def sinobigami_emotion_table()
    table = [
             '共感（プラス）／不信（マイナス）',
             '友情（プラス）／怒り（マイナス）',
             '愛情（プラス）／妬み（マイナス）',
             '忠誠（プラス）／侮蔑（マイナス）',
             '憧憬（プラス）／劣等感（マイナス）',
             '狂信（プラス）／殺意（マイナス）',
            ]

    return get_sinobigami_1d6_table_output("感情表", table)
  end

  # 変調表
  def sinobigami_wrong_table(string)
    table = []
    type = ''

    case string
    when /GWT/
      type = '戦国'
      table = [
               '催眠:戦闘に参加した時、戦闘開始時、もしくはこの変調を受けた時に【生命力】を1点減少しないと、戦闘から脱落する。サイクル終了時に〈意気〉判定し成功すると無効化。',
               '火達磨:ファンブル値が1上昇し、ファンブル時に1点の近接ダメージを受ける。シーン終了時に無効化。',
               '猛毒:戦闘に参加した時、ラウンドの終了時にサイコロを1つ振る(飢餓と共用)。奇数だったら【生命力】を1減少。サイクル終了時に〈毒術〉判定し成功すると無効化。',
               '飢餓:戦闘に参加した時、ラウンドの終了時にサイコロを1つ振る(猛毒と共用)。偶数だったら【生命力】を1減少。サイクル終了時に〈兵糧術〉判定し成功すると無効化。',
               '残刃:回復判定、忍法、背景、忍具の効果による【生命力】回復無効。サイクル終了時に〈拷問術〉判定し成功すると無効化。',
               '野望:命中判定に+1、それ以外の判定に-1。サイクル終了時に〈憑依術〉判定し成功すると無効化。',
              ]
    when /KWT/
      type = '怪'
      table = [
               '故障:すべての忍具が使用不能になる。この効果は累積しない。各サイクルの終了時に、《絡繰術》で行為判定を行い、成功するとこの変調は無効化される。',
               'マヒ:修得している特技の中からランダムに一つを選び、その特技が使用不能になる。この効果は、修得している特技の数だけ累積する。各サイクルの終了時に、《身体操術l》で行為判定を行い、成功するとこの変調はすべて無効化される。',
               '重傷:命中判定、情報判定、感情判定を行うたびに、接近戦ダメージを１点受ける。この効果は累積しない。各サイクルの終了時に、《生存術》で行為判定を行い、成功するとこの変調は無効化される。',
               '行方不明:メインフェイズ中、自分以外がシーンプレイヤーのシーンに登場することができなくなる。この効果は累積しない。各サイクルの終了時に、《経済力》で行為判定を行い、成功するとこの変調は無効化される。',
               '忘却:修得している【感情】の中からランダムに一つを選び、その【感情】を持っていないものとして扱う。この効果は、修得している【感情】の数だけ累積する。各サイクルの終了時に、《記憶術》で行為判定を行い、成功するとこの変調はすべて無効化される。',
               '呪い:修得している忍法の中からランダムに一つを選び、その忍法を修得していないものとして扱う。この効果は、修得している忍法の数だけ累積する。各サイクルの終了時に、《呪術》で行為判定を行い、成功するとこの変調はすべて無効化される。',
              ]
    else
      table = [
               '故障:すべての忍具が使用不能。１サイクルの終了時に、《絡繰術》で判定を行い、成功するとこの効果は無効化される。',
               'マヒ:修得済み特技がランダムに１つ使用不能になる。１サイクルの終了時に、《身体操術》で成功するとこの効果は無効化される。',
               '重傷:次の自分の手番に行動すると、ランダムな特技分野１つの【生命力】に１点ダメージ。１サイクルの終了時に、《生存術》で成功すると無効化される。',
               '行方不明:その戦闘終了後、メインフェイズ中に行動不可。１サイクルの終了時に、《経済力》で成功すると無効化される。',
               '忘却:修得済み感情がランダムに１つ使用不能。１サイクルの終了時に、《記憶術》で成功すると無効化される。',
               '呪い:修得済み忍法がランダムに１つ使用不能。１サイクルの終了時に、《呪術》で成功すると無効化される。',
              ]
    end

    return get_sinobigami_1d6_table_output("#{type}変調表", table)
  end

  # 戦場表
  def sinobigami_battlefield_table()
    table = [
             '平地:特になし。',
             '水中:海や川や、プール、血の池地獄など。この戦場では、回避判定に-2の修正がつく。',
             '高所:ビルの谷間や樹上、断崖絶壁など。この戦場でファンブルすると1点のダメージを受ける。',
             '悪天候:嵐や吹雪、ミサイルの雨など。この戦場では、すべての攻撃忍法の間合が１上昇する。',
             '雑踏:人混みや教室、渋滞中の車道など。この戦場では、行為判定のとき、2D6の目がプロット値+1以下だとファンブルする。',
             '極地:宇宙や深海、溶岩、魔界など。ラウンドの終わりにＧＭが1D6を振り、経過ラウンド以下なら全員1点ダメージ。ここから脱落したものは変調表を適用する。',
            ]

    return get_sinobigami_1d6_table_output("戦場表", table)
  end

  # 指定特技ランダム決定表
  def sinobigami_random_skill_table()
    output = '1'
    type = 'ランダム'

    skillTableFull = [
                      ['器術', ['絡繰術','火術','水術','針術','仕込み','衣装術','縄術','登術','拷問術','壊器術','掘削術']],
                      ['体術', ['騎乗術','砲術','手裏剣術','手練','身体操術','歩法','走法','飛術','骨法術','刀術','怪力']],
                      ['忍術', ['生存術','潜伏術','遁走術','盗聴術','腹話術','隠形術','変装術','香術','分身の術','隠蔽術','第六感']],
                      ['謀術', ['医術','毒術','罠術','調査術','詐術','対人術','遊芸','九ノ一の術','傀儡の術','流言の術','経済力']],
                      ['戦術', ['兵糧術','鳥獣術','野戦術','地の利','意気','用兵術','記憶術','見敵術','暗号術','伝達術','人脈']],
                      ['妖術', ['異形化','召喚術','死霊術','結界術','封術','言霊術','幻術','瞳術','千里眼の術','憑依術','呪術']],
                     ]

    skillTable, total_n = get_table_by_1d6(skillTableFull)
    tableName, skillTable = skillTable
    skill, total_n2 = get_table_by_2d6(skillTable)

    output = "#{type}指定特技表(#{total_n},#{total_n2}) ＞ 『#{tableName}』#{skill}"

    return output
  end

  # 異形表
  def sinobigami_metamorphose_table()
    output = '1'
    tableName = "異形表"
    table = [
             '1D6を振り、「妖魔忍法表A」で、ランダムに忍法の種類を決定する。妖魔化している間、その妖魔忍法を修得しているものとして扱う。この異形は、違う種類の妖魔忍法である限り、違う異形として扱う。',
             '1D6を振り、「妖魔忍法表B」で、ランダムに忍法の種類を決定する。妖魔化している間、その妖魔忍法を修得しているものとして扱う。この異形は、違う種類の妖魔忍法である限り、違う異形として扱う。',
             '1D6を振り、「妖魔忍法表C」で、ランダムに忍法の種類を決定する。妖魔化している間、その妖魔忍法を修得しているものとして扱う。この異形は、違う種類の妖魔忍法である限り、違う異形として扱う。',
             '妖魔化している間、戦闘中、1ラウンドに使用できる忍法のコストが、自分のプロット値+3点になり、装備忍法の【揺音】を修得する。',
             '妖魔化している間、【接近戦攻撃】によって与える接近戦ダメージが2点になる。',
             '妖魔化している間、このキャラクターの攻撃に対する回避判定と、このキャラクターの奥義に対する奥義破り判定にマイナス1の修正がつく。'
            ]
    total_n, = roll(1, 6)
    text = table[total_n - 1]
    return '1' if( text.nil? )

    output = "#{tableName}(#{total_n}) ＞ #{text}"

    if (total_n > 3)
      return output
    end

    powerTable = []
    powerType = ""
    powerPage = ""
    case total_n
    when 1
      powerType = "妖魔忍法表A"
      powerPage = "(怪p.252)"
      powerTable = [
                    '【震々】',
                    '【神隠】',
                    '【夜雀】',
                    '【猟犬】',
                    '【逢魔時】',
                    '【狂骨】',
                   ]
    when 2
      powerType = "妖魔忍法表B"
      powerPage = "(怪p.253)"
      powerTable = [
                    '【野衾】',
                    '【付喪神】',
                    '【見越】',
                    '【木魂】',
                    '【鵺】',
                    '【生剥】',
                   ]
    when 3
      powerType = "妖魔忍法表C"
      powerPage = "(怪p.254)"
      powerTable = [
                    '【百眼】',
                    '【呑口】',
                    '【荒吐】',
                    '【怨霊】',
                    '【鬼火】',
                    '【蛭子】',
                   ]
    end

    total_n, = roll(1, 6)
    text = powerTable[total_n - 1]
    return '1' if( text.nil? )

    output += " #{powerType} ＞ #{ text }#{ powerPage }"

    return output
  end
end
