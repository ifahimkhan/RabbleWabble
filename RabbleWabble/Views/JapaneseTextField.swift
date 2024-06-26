//
//  JapaneseTextField.swift
//  RabbleWabble
//
//  Created by Ragesh on 4/26/24.
//

import UIKit

public class JapaneseTextField: UITextField {

  public enum Mode {
    case caseBased
    case hiragana
    case katakana

    fileprivate var characterChart: CharacterConversionChart.Type {
      switch self {
      case .caseBased: return CaseBasedChart.self
      case .hiragana: return HiraganaChart.self
      case .katakana: return KatakanaChart.self
      }
    }
  }

  public var mode: Mode = .caseBased

  // MARK: - Object Lifecycle
  public override init(frame: CGRect) {
    super.init(frame: frame)
    registerForTextChanges()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    registerForTextChanges()
  }

  private func registerForTextChanges() {
    addTarget(self, action: #selector(textDidChange), for: .editingChanged)
  }

  public override var textInputMode: UITextInputMode? {
    if let inputMode = UITextInputMode.activeInputModes.filter({ (inputMode) -> Bool in
      guard let primaryLanguage = inputMode.primaryLanguage,
        primaryLanguage == "ja-JP" else {
          return false
      }
      return true
    }).first {
      return inputMode
    }
    return super.textInputMode
  }

  @objc private func textDidChange() {
    if let textInputMode = textInputMode?.primaryLanguage,
      textInputMode.contains("JP") {
      return
    }
    guard let text = text, text.count > 0 else {
      return
    }
    self.text = text.convertText(using: mode.characterChart)
  }
}

public extension String {

  func toHirigana() -> String {
    return convertText(using: HiraganaChart.self)
  }

  func toKatakana() -> String {
    return convertText(using: KatakanaChart.self)
  }

  fileprivate func convertText(using chart: CharacterConversionChart.Type) -> String {
    var text = self
    var position = 0
    while position < text.count {
      if convertText(&text, startPosition: position, offset: 3, chart: chart) {
        position += 4

      } else if convertText(&text, startPosition: position, offset: 2, chart: chart) {
        position += 3

      } else if convertText(&text, startPosition: position, offset: 1, chart: chart) {
        position += 2

      } else {
        convertText(&text, startPosition: position, offset: 0, chart: chart)
        position += 1
      }
    }
    return text
  }

  @discardableResult private func convertText(_ text: inout String,
                                              startPosition: Int,
                                              offset: Int,
                                              chart: CharacterConversionChart.Type) -> Bool {

    guard startPosition + offset < text.count else { return false }

    let startIndex = text.index(text.startIndex, offsetBy: startPosition)
    let endIndex = text.index(startIndex, offsetBy: offset)
    let key = String(text[startIndex...endIndex])

    guard let replacement = chart.lookupTable[key] else { return false }
    text.replaceSubrange(startIndex...endIndex, with: replacement)

    return true
  }
}

// MARK: - CharacterConversionChart
fileprivate protocol CharacterConversionChart {
  static var lookupTable: [String: String] { get }
}

// MARK: - CaseBasedChart
fileprivate struct CaseBasedChart: CharacterConversionChart {
  fileprivate static let lookupTable: [String: String] = {
    let hiraganaTable = HiraganaChart.lookupTable
    var katakanaTable = KatakanaChart.lookupTable
    for key in katakanaTable.keys {
      katakanaTable[key.uppercased()] = katakanaTable.removeValue(forKey: key)
    }
    return hiraganaTable.merging(katakanaTable) { (current, _) in return current }
  }()
}

// MARK: - HiraganaChart
fileprivate struct HiraganaChart: CharacterConversionChart {

  // Derived from: https://github.com/WaniKani/WanaKana/blob/master/src/constants.js
  fileprivate static let lookupTable = [
    ".": "。",
    ",": "、",
    ":": "：",
    "/": "・",
    "!": "！",
    "?": "？",
    "~": "〜",
    "-": "ー",
    "‘": "「",
    "’": "」",
    "“": "『",
    "”": "』",
    "[": "［",
    "]": "］",
    "(": "（",
    ")": "）",
    "{": "｛",
    "}": "｝",

    "a": "あ",
    "i": "い",
    "u": "う",
    "e": "え",
    "o": "お",
    "yi": "い",
    "wu": "う",
    "whu": "う",
    "xa": "ぁ",
    "xi": "ぃ",
    "xu": "ぅ",
    "xe": "ぇ",
    "xo": "ぉ",
    "xyi": "ぃ",
    "xye": "ぇ",
    "ye": "いぇ",
    "wha": "うぁ",
    "whi": "うぃ",
    "whe": "うぇ",
    "who": "うぉ",
    "wi": "うぃ",
    "we": "うぇ",
    "va": "ゔぁ",
    "vi": "ゔぃ",
    "vu": "ゔ",
    "ve": "ゔぇ",
    "vo": "ゔぉ",
    "vya": "ゔゃ",
    "vyi": "ゔぃ",
    "vyu": "ゔゅ",
    "vye": "ゔぇ",
    "vyo": "ゔょ",
    "ka": "か",
    "ki": "き",
    "ku": "く",
    "ke": "け",
    "ko": "こ",
    "lka": "ヵ",
    "lke": "ヶ",
    "xka": "ヵ",
    "xke": "ヶ",
    "kya": "きゃ",
    "kyi": "きぃ",
    "kyu": "きゅ",
    "kye": "きぇ",
    "kyo": "きょ",
    "ca": "か",
    "ci": "き",
    "cu": "く",
    "ce": "け",
    "co": "こ",
    "lca": "ヵ",
    "lce": "ヶ",
    "xca": "ヵ",
    "xce": "ヶ",
    "qya": "くゃ",
    "qyu": "くゅ",
    "qyo": "くょ",
    "qwa": "くぁ",
    "qwi": "くぃ",
    "qwu": "くぅ",
    "qwe": "くぇ",
    "qwo": "くぉ",
    "qa": "くぁ",
    "qi": "くぃ",
    "qe": "くぇ",
    "qo": "くぉ",
    "kwa": "くぁ",
    "qyi": "くぃ",
    "qye": "くぇ",
    "ga": "が",
    "gi": "ぎ",
    "gu": "ぐ",
    "ge": "げ",
    "go": "ご",
    "gya": "ぎゃ",
    "gyi": "ぎぃ",
    "gyu": "ぎゅ",
    "gye": "ぎぇ",
    "gyo": "ぎょ",
    "gwa": "ぐぁ",
    "gwi": "ぐぃ",
    "gwu": "ぐぅ",
    "gwe": "ぐぇ",
    "gwo": "ぐぉ",
    "sa": "さ",
    "si": "し",
    "shi": "し",
    "su": "す",
    "se": "せ",
    "so": "そ",
    "za": "ざ",
    "zi": "じ",
    "zu": "ず",
    "ze": "ぜ",
    "zo": "ぞ",
    "ji": "じ",
    "sya": "しゃ",
    "syi": "しぃ",
    "syu": "しゅ",
    "sye": "しぇ",
    "syo": "しょ",
    "sha": "しゃ",
    "shu": "しゅ",
    "she": "しぇ",
    "sho": "しょ",
    "shya": "しゃ",
    "shyu": "しゅ",
    "shye": "しぇ",
    "shyo": "しょ",
    "swa": "すぁ",
    "swi": "すぃ",
    "swu": "すぅ",
    "swe": "すぇ",
    "swo": "すぉ",
    "zya": "じゃ",
    "zyi": "じぃ",
    "zyu": "じゅ",
    "zye": "じぇ",
    "zyo": "じょ",
    "ja": "じゃ",
    "ju": "じゅ",
    "je": "じぇ",
    "jo": "じょ",
    "jya": "じゃ",
    "jyi": "じぃ",
    "jyu": "じゅ",
    "jye": "じぇ",
    "jyo": "じょ",
    "ta": "た",
    "ti": "ち",
    "tu": "つ",
    "te": "て",
    "to": "と",
    "chi": "ち",
    "tsu": "つ",
    "ltu": "っ",
    "xtu": "っ",
    "tya": "ちゃ",
    "tyi": "ちぃ",
    "tyu": "ちゅ",
    "tye": "ちぇ",
    "tyo": "ちょ",
    "cha": "ちゃ",
    "chu": "ちゅ",
    "che": "ちぇ",
    "cho": "ちょ",
    "cya": "ちゃ",
    "cyi": "ちぃ",
    "cyu": "ちゅ",
    "cye": "ちぇ",
    "cyo": "ちょ",
    "chya": "ちゃ",
    "chyu": "ちゅ",
    "chye": "ちぇ",
    "chyo": "ちょ",
    "tsa": "つぁ",
    "tsi": "つぃ",
    "tse": "つぇ",
    "tso": "つぉ",
    "tha": "てゃ",
    "thi": "てぃ",
    "thu": "てゅ",
    "the": "てぇ",
    "tho": "てょ",
    "twa": "とぁ",
    "twi": "とぃ",
    "twu": "とぅ",
    "twe": "とぇ",
    "two": "とぉ",
    "da": "だ",
    "di": "ぢ",
    "du": "づ",
    "de": "で",
    "do": "ど",
    "dya": "ぢゃ",
    "dyi": "ぢぃ",
    "dyu": "ぢゅ",
    "dye": "ぢぇ",
    "dyo": "ぢょ",
    "dha": "でゃ",
    "dhi": "でぃ",
    "dhu": "でゅ",
    "dhe": "でぇ",
    "dho": "でょ",
    "dwa": "どぁ",
    "dwi": "どぃ",
    "dwu": "どぅ",
    "dwe": "どぇ",
    "dwo": "どぉ",
    "na": "な",
    "ni": "に",
    "nu": "ぬ",
    "ne": "ね",
    "no": "の",
    "nya": "にゃ",
    "nyi": "にぃ",
    "nyu": "にゅ",
    "nye": "にぇ",
    "nyo": "にょ",
    "ha": "は",
    "hi": "ひ",
    "hu": "ふ",
    "he": "へ",
    "ho": "ほ",
    "fu": "ふ",
    "hya": "ひゃ",
    "hyi": "ひぃ",
    "hyu": "ひゅ",
    "hye": "ひぇ",
    "hyo": "ひょ",
    "fya": "ふゃ",
    "fyu": "ふゅ",
    "fyo": "ふょ",
    "fwa": "ふぁ",
    "fwi": "ふぃ",
    "fwu": "ふぅ",
    "fwe": "ふぇ",
    "fwo": "ふぉ",
    "fa": "ふぁ",
    "fi": "ふぃ",
    "fe": "ふぇ",
    "fo": "ふぉ",
    "fyi": "ふぃ",
    "fye": "ふぇ",
    "ba": "ば",
    "bi": "び",
    "bu": "ぶ",
    "be": "べ",
    "bo": "ぼ",
    "bya": "びゃ",
    "byi": "びぃ",
    "byu": "びゅ",
    "bye": "びぇ",
    "byo": "びょ",
    "pa": "ぱ",
    "pi": "ぴ",
    "pu": "ぷ",
    "pe": "ぺ",
    "po": "ぽ",
    "pya": "ぴゃ",
    "pyi": "ぴぃ",
    "pyu": "ぴゅ",
    "pye": "ぴぇ",
    "pyo": "ぴょ",
    "ma": "ま",
    "mi": "み",
    "mu": "む",
    "me": "め",
    "mo": "も",
    "mya": "みゃ",
    "myi": "みぃ",
    "myu": "みゅ",
    "mye": "みぇ",
    "myo": "みょ",
    "ya": "や",
    "yu": "ゆ",
    "yo": "よ",
    "xya": "ゃ",
    "xyu": "ゅ",
    "xyo": "ょ",
    "ra": "ら",
    "ri": "り",
    "ru": "る",
    "re": "れ",
    "ro": "ろ",
    "rya": "りゃ",
    "ryi": "りぃ",
    "ryu": "りゅ",
    "rye": "りぇ",
    "ryo": "りょ",
    "la": "ら",
    "li": "り",
    "lu": "る",
    "le": "れ",
    "lo": "ろ",
    "lya": "りゃ",
    "lyi": "りぃ",
    "lyu": "りゅ",
    "lye": "りぇ",
    "lyo": "りょ",
    "wa": "わ",
    "wo": "を",
    "lwe": "ゎ",
    "xwa": "ゎ",
    "nn": "ん",
    "n\"": "ん",
    "n ": "ん",
    "xn": "ん",
    "ltsu": "っ",

    "bb": "っb",
    "cc": "っc",
    "dd": "っd",
    "ff": "っf",
    "gg": "っg",
    "hh": "っh",
    "jj": "っj",
    "kk": "っk",
    "ll": "っl",
    "mm": "っm",
    "pp": "っp",
    "qq": "っq",
    "rr": "っr",
    "ss": "っs",
    "tt": "っt",
    "vv": "っv",
    "ww": "っw",
    "xx": "っx",
    "yy": "っy",
    "zz": "っz",
  ]
}

// MARK: - KatakanaChart
fileprivate struct KatakanaChart: CharacterConversionChart {

  fileprivate static let lookupTable = [
    ".": "。",
    ",": "、 ",
    ":": "：",
    "/": "・",
    "!": "！",
    "?": "？",
    "~": "〜",
    "-": "ー",
    "‘": "「",
    "’": "」",
    "“": "『",
    "”": "』",
    "[": "［",
    "]": "］",
    "(": "（",
    ")": "）",
    "{": "｛",
    "}": "｝",

    "a": "ア",
    "i": "イ",
    "u": "ウ",
    "e": "エ",
    "o": "オ",
    "yi": "イ",
    "wu": "ウ",
    "whu": "ウ",
    "xa": "ァ",
    "xi": "ィ",
    "xu": "ゥ",
    "xe": "ェ",
    "xo": "ォ",
    "xyi": "ィ",
    "xye": "ェ",
    "ye": "イェ",
    "wha": "ウァ",
    "whi": "ウィ",
    "whe": "ウェ",
    "who": "ウォ",
    "wi": "ウィ",
    "we": "ウェ",
    "va": "ヴァ",
    "vi": "ヴィ",
    "vu": "ヴ",
    "ve": "ヴェ",
    "vo": "ヴォ",
    "vya": "ヴャ",
    "vyi": "ヴィ",
    "vyu": "ヴュ",
    "vye": "ヴェ",
    "vyo": "ヴョ",
    "ka": "カ",
    "ki": "キ",
    "ku": "ク",
    "ke": "ケ",
    "ko": "コ",
    "lka": "ヵ",
    "lke": "ヶ",
    "xka": "ヵ",
    "xke": "ヶ",
    "kya": "キャ",
    "kyi": "キィ",
    "kyu": "キュ",
    "kye": "キェ",
    "kyo": "キョ",
    "ca": "カ",
    "ci": "キ",
    "cu": "ク",
    "ce": "ケ",
    "co": "コ",
    "lca": "ヵ",
    "lce": "ヶ",
    "xca": "ヵ",
    "xce": "ヶ",
    "qya": "キャ",
    "qyu": "キュ",
    "qyo": "キョ",
    "qwa": "クァ",
    "qwi": "クィ",
    "qwu": "クゥ",
    "qwe": "クェ",
    "qwo": "クォ",
    "qa": "クァ",
    "qi": "クィ",
    "qe": "クェ",
    "qo": "クォ",
    "kwa": "クァ",
    "qyi": "キィ",
    "qye": "キェ",
    "ga": "ガ",
    "gi": "ギ",
    "gu": "グ",
    "ge": "ゲ",
    "go": "ゴ",
    "gya": "ギャ",
    "gyi": "ギィ",
    "gyu": "ギュ",
    "gye": "ギェ",
    "gyo": "ギョ",
    "gwa": "グァ",
    "gwi": "グィ",
    "gwu": "グゥ",
    "gwe": "グェ",
    "gwo": "グォ",
    "sa": "サ",
    "si": "シ",
    "shi": "シ",
    "su": "ス",
    "se": "セ",
    "so": "ソ",
    "za": "ザ",
    "zi": "ジ",
    "zu": "ズ",
    "ze": "ゼ",
    "zo": "ゾ",
    "ji": "ジ",
    "sya": "シャ",
    "syi": "シィ",
    "syu": "シュ",
    "sye": "シェ",
    "syo": "ショ",
    "sha": "シャ",
    "shu": "シュ",
    "she": "シェ",
    "sho": "ショ",
    "shya": "シャ",
    "shyu": "シュ",
    "shye": "シェ",
    "shyo": "ショ",
    "swa": "スァ",
    "swi": "スィ",
    "swu": "スゥ",
    "swe": "スェ",
    "swo": "スォ",
    "zya": "ジャ",
    "zyi": "ジィ",
    "zyu": "ジュ",
    "zye": "ジェ",
    "zyo": "ジョ",
    "ja": "ジャ",
    "ju": "ジュ",
    "je": "ジェ",
    "jo": "ジョ",
    "jya": "ジャ",
    "jyi": "ジィ",
    "jyu": "ジュ",
    "jye": "ジェ",
    "jyo": "ジョ",
    "ta": "タ",
    "ti": "チ",
    "tu": "ツ",
    "te": "テ",
    "to": "ト",
    "chi": "チ",
    "tsu": "ツ",
    "ltu": "ッ",
    "xtu": "ッ",
    "tya": "チャ",
    "tyi": "チィ",
    "tyu": "チュ",
    "tye": "チェ",
    "tyo": "チョ",
    "cha": "チャ",
    "chu": "チュ",
    "che": "チェ",
    "cho": "チョ",
    "cya": "チャ",
    "cyi": "チィ",
    "cyu": "チュ",
    "cye": "チェ",
    "cyo": "チョ",
    "chya": "チャ",
    "chyu": "チュ",
    "chye": "チェ",
    "chyo": "チョ",
    "tsa": "ツァ",
    "tsi": "ツィ",
    "tse": "ツェ",
    "tso": "ツォ",
    "tha": "テャ",
    "thi": "ティ",
    "thu": "テュ",
    "the": "テェ",
    "tho": "テョ",
    "twa": "トァ",
    "twi": "トィ",
    "twu": "トゥ",
    "twe": "トェ",
    "two": "トォ",
    "da": "ダ",
    "di": "ヂ",
    "du": "ヅ",
    "de": "デ",
    "do": "ド",
    "dya": "ヂャ",
    "dyi": "ヂィ",
    "dyu": "ヂュ",
    "dye": "ヂェ",
    "dyo": "ヂョ",
    "dha": "デャ",
    "dhi": "ディ",
    "dhu": "デュ",
    "dhe": "デェ",
    "dho": "デョ",
    "dwa": "ドァ",
    "dwi": "ドィ",
    "dwu": "ドゥ",
    "dwe": "ドェ",
    "dwo": "ドォ",
    "na": "ナ",
    "ni": "ニ",
    "nu": "ヌ",
    "ne": "ネ",
    "no": "ノ",
    "nya": "ニャ",
    "nyi": "ニィ",
    "nyu": "ニュ",
    "nye": "ニェ",
    "nyo": "ニョ",
    "ha": "ハ",
    "hi": "ヒ",
    "hu": "フ",
    "he": "ヘ",
    "ho": "ホ",
    "fu": "フ",
    "hya": "ヒャ",
    "hyi": "ヒィ",
    "hyu": "ヒュ",
    "hye": "ヒェ",
    "hyo": "ヒョ",
    "fya": "フャ",
    "fyu": "フュ",
    "fyo": "フョ",
    "fwa": "ファ",
    "fwi": "フィ",
    "fwu": "フゥ",
    "fwe": "フェ",
    "fwo": "フォ",
    "fa": "ファ",
    "fi": "フィ",
    "fe": "フェ",
    "fo": "フォ",
    "fyi": "フィ",
    "fye": "フェ",
    "ba": "バ",
    "bi": "ビ",
    "bu": "ブ",
    "be": "ベ",
    "bo": "ボ",
    "bya": "ビャ",
    "byi": "ビィ",
    "byu": "ビュ",
    "bye": "ビェ",
    "byo": "ビョ",
    "pa": "パ",
    "pi": "ピ",
    "pu": "プ",
    "pe": "ペ",
    "po": "ポ",
    "pya": "ピャ",
    "pyi": "ピィ",
    "pyu": "ピュ",
    "pye": "ピェ",
    "pyo": "ピョ",
    "ma": "マ",
    "mi": "ミ",
    "mu": "ム",
    "me": "メ",
    "mo": "モ",
    "mya": "ミャ",
    "myi": "ミィ",
    "myu": "ミュ",
    "mye": "ミェ",
    "myo": "ミョ",
    "ya": "ヤ",
    "yu": "ユ",
    "yo": "ヨ",
    "xya": "ャ",
    "xyu": "ュ",
    "xyo": "ョ",
    "ra": "ラ",
    "ri": "リ",
    "ru": "ル",
    "re": "レ",
    "ro": "ロ",
    "rya": "リャ",
    "ryi": "リィ",
    "ryu": "リュ",
    "rye": "リェ",
    "ryo": "リョ",
    "la": "ラ",
    "li": "リ",
    "lu": "ル",
    "le": "レ",
    "lo": "ロ",
    "lya": "リャ",
    "lyi": "リィ",
    "lyu": "リュ",
    "lye": "リェ",
    "lyo": "リョ",
    "wa": "ワ",
    "wo": "ヲ",
    "lwe": "ヮ",
    "xwa": "ヮ",
    "nn": "ン",
    "n\"": "ン",
    "n ": "ン",
    "xn": "ン",
    "ltsu": "ッ",

    "bb": "ッb",
    "cc": "ッc",
    "dd": "ッd",
    "ff": "ッf",
    "gg": "ッg",
    "hh": "ッh",
    "jj": "ッj",
    "kk": "ッk",
    "ll": "ッl",
    "mm": "ッm",
    "pp": "ッp",
    "qq": "ッq",
    "rr": "ッr",
    "ss": "ッs",
    "tt": "ッt",
    "vv": "ッv",
    "ww": "ッw",
    "xx": "ッx",
    "yy": "ッy",
    "zz": "ッz",
    ]
}
