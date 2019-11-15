# hangul_naming_score
한글 이름궁합 swift 소스
========================

한글 이름궁합을 보는 swift 샘플코드가 없어서 직접 만들었습니다.

xcode playground 기준으로 개발되었습니다.

* 점수가 10점보다 작은 경우 100-점수 로 표시함


#사용방법
---------

NamingUtil.swift import 후 아래의 코드로 이용가능합니다.

<pre><code>
NamingUtil.matchingScore(name1: name1, name2: name2)
</code></pre>

##예시
---------
<pre><code>
// 한글 체크
var name1 = "홍길동"
var name2 = "이길순"

var isValid = true
if name1.count < 2 || name1.count > 3 || !NamingUtil.isHangul(name: name1) {
    print("name1's length is 2~3 and it is only Hangul.")
    isValid = false
}

if name2.count < 2 || name2.count > 3 || !NamingUtil.isHangul(name: name2) {
    print("name2's length is 2~3 and it is only Hangul")
    isValid = false
}

// NamingUtil.matchingScore(name1: "test1", name2: "test2")
if isValid {
    print("\(name1)님이 \(name2)님을 생각하는 마음: " + String(NamingUtil.matchingScore(name1: name1, name2: name2)) + "점")
    print("\(name2)님이 \(name1)님을 생각하는 마음: " + String(NamingUtil.matchingScore(name1: name2, name2: name1)) + "점")
} else {
    print("유효한 입력이 아닙니다.")
}
</code></pre>

결과:
--------
홍길동님이 이길순님을 생각하는 마음: 98점
이길순님이 홍길동님을 생각하는 마음: 26점
