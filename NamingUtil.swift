//  Created by Star_Man on 2019/11/15.
//  Copyright (c) 2019 Star_Man. All rights reserved.

import Foundation
import UIKit

public class NamingUtil {
//    private static let PATTERN_HANGUL: String = "^[가-힣ㄱ-ㅎㅏ-ㅣ\u{318D}\u{119E}\u{11A2}\u{2022}\u{2025a}\u{00B7}\u{FE55}]+$"
    private static let PATTERN_HANGUL: String = "^[가-힣]+$"

    // First '가' : 0xAC00(44032), 끝 '힟' : 0xD79F(55199)
    private static let FIRST_HANGUL: Int = 44032
    public static let HANGUL_END_UNICODE: Int = 55203 // 힣
    public static let HANGUL_BASE_UNIT: Int = 588 // 각자음 마다 가지는 글자수
    private static let JUNGSUNG_COUNT: Int = 21
    private static let JONGSUNG_COUNT: Int = 28

    // 19 initial consonants
    private static let CHOSUNG_LIST = [
        "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ",
        "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
    ]

    // 21 vowels
    private static let JUNGSUNG_LIST = [
        "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ",
        "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ",
        "ㅣ"
    ]

    // 28 consonants placed under a vowel(plus one empty character)
    private static let JONGSUNG_LIST = [
        " ", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ",
        "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ",
        "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
    ]

    private static let STROKE_MAP: [String: Int] = [
        " ": 0,
        "ㄱ": 2,
        "ㄲ": 4,
        "ㄴ": 2,
        "ㄷ": 3,
        "ㄸ": 6,
        "ㄹ": 5,
        "ㅁ": 4,
        "ㅂ": 4,
        "ㅃ": 8,
        "ㅅ": 2,
        "ㅆ": 4,
        "ㅇ": 1,
        "ㅈ": 3,
        "ㅉ": 6,
        "ㅊ": 4,
        "ㅋ": 3,
        "ㅌ": 4,
        "ㅍ": 4,
        "ㅎ": 3,
        "ㅏ": 2,
        "ㅐ": 3,
        "ㅑ": 3,
        "ㅒ": 4,
        "ㅓ": 2,
        "ㅔ": 3,
        "ㅕ": 3,
        "ㅖ": 4,
        "ㅗ": 2,
        "ㅘ": 4,
        "ㅙ": 5,
        "ㅚ": 3,
        "ㅛ": 3,
        "ㅜ": 2,
        "ㅝ": 4,
        "ㅞ": 5,
        "ㅟ": 3,
        "ㅠ": 3,
        "ㅡ": 1,
        "ㅢ": 2,
        "ㅣ": 1,
        "ㄳ": 4,
        "ㄵ": 5,
        "ㄶ": 5,
        "ㄺ": 7,
        "ㄻ": 9,
        "ㄼ": 9,
        "ㄽ": 7,
        "ㄾ": 9,
        "ㄿ": 9,
        "ㅀ": 8,
        "ㅄ": 6
    ]

    public static func matchingScore(name1: String, name2: String) -> Int {
        if name1.count < 2 || name1.count > 3 || !isHangul(name: name1) {
            print("name1's length is 2~3 and it is only Hangul.")
            return -1
        }
        if name2.count < 2 || name2.count > 3 || !isHangul(name: name2) {
            print("name2's length is 2~3 and it is only Hangul")
            return -1
        }

        let name1str = name1.count == 2 ? name1 + " " : name1
        let name2str = name2.count == 2 ? name2 + " " : name2

        let arrName1 = Array(name1str)
        let arrName2 = Array(name2str)

        let arrSumStr = [arrName1[0], arrName2[0], arrName1[1], arrName2[1], arrName1[2], arrName2[2]]

        var arrSumCnt: [Int] = Array()
        for item in arrSumStr {
            arrSumCnt.append(getStockCnt(str: String(item)))
        }

        var arrLast: [Int] = Array()
        repeat {
            arrLast.removeAll()
            for i in 0 ..< arrSumCnt.count - 1 {
                let cnt = (arrSumCnt[i] + arrSumCnt[i + 1]) % 10
                arrLast.append(cnt)
            }
            arrSumCnt.removeAll()
            arrSumCnt.append(contentsOf: arrLast)
        } while arrLast.count > 2

        var sum = 0
        if arrLast.count >= 2 {
            sum = arrLast[0] * 10 + arrLast[1]
        }

        if sum < 10 {
            sum = 100 - sum
        }

        return sum
    }

    public static func isHangul(name: String) -> Bool {
        return checkRegexp(regexpStr: PATTERN_HANGUL, targetStr: name)
    }

    private static func checkRegexp(regexpStr: String, targetStr: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regexpStr)
            if regex.firstMatch(in: targetStr, options: .reportCompletion, range: NSMakeRange(0, targetStr.count)) != nil {
                return true
            }
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }

        return false
    }

    private static func getStockCnt(str: String) -> Int {
        let arrChar: [String] = spiltJamoChar(str: str)
        var sum: Int = 0
        for i in 0 ..< arrChar.count {
            sum += STROKE_MAP[arrChar[i]] ?? 0
        }
        return sum
    }

    private static func spiltJamoChar(str: String) -> [String] {
        var jasoList: [String] = Array()
        if checkRegexp(regexpStr: ".*[가-힣]+.*", targetStr: str) {
            let baseCode = Int(UnicodeScalar(str)?.value ?? 0) - FIRST_HANGUL
            let chosungIndex = baseCode / (JONGSUNG_COUNT * JUNGSUNG_COUNT)
            jasoList.append(String(CHOSUNG_LIST[chosungIndex]))

            let jungsungIndex = (baseCode - ((JONGSUNG_COUNT * JUNGSUNG_COUNT) * chosungIndex)) / JONGSUNG_COUNT
            jasoList.append(String(JUNGSUNG_LIST[jungsungIndex]))

            let jongsungIndex = (baseCode - ((JONGSUNG_COUNT * JUNGSUNG_COUNT) * chosungIndex) - (JONGSUNG_COUNT * jungsungIndex))
            if jongsungIndex > 0 {
                jasoList.append(String(JONGSUNG_LIST[jongsungIndex]))
            }

        } else if checkRegexp(regexpStr: ".*[ㄱ-ㅎ]+.*", targetStr: str) {
            print("음절이 아닌 자음입니다.")
        } else if checkRegexp(regexpStr: ".*[ㄱ-ㅎ]+.*", targetStr: str) {
            print("음절이 아닌 모음입니다.")
        } else {
            print("한글이 아닙니다.")
        }

        return jasoList
    }
}
