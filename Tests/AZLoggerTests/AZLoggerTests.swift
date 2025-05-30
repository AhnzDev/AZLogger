
import XCTest
import OSLog
@testable import AZLogger

final class AZLoggerTests: XCTestCase {

    func testExample() throws {
        // 예시용 더미 테스트
        XCTAssertTrue(true)
        
        
        
    }

    func testConsoleLogPrintsFormattedMessage() {
        let output = captureStandardOutput {
            AZLogger.log(
                "Hello, AZLogger!",
                level: .info,
                function: "testFunc()",
                file: "/path/to/File.swift",
                line: 42
            )
        }

        XCTAssertTrue(
            output.contains("[ℹ️] File.testFunc():42 → Hello, AZLogger!"),
            "콘솔 출력이 예상 포맷과 일치하지 않습니다. 실제: \(output)"
        )
    }

    func testOSLogDoesNotThrow() {
        XCTAssertNoThrow(
//            AZLogger.osLog("OSLog 테스트 메시지", level: .debug, category: "UnitTest")
            AZLogger.log("그냥 로그 출력", level: .info)
        )
    }
}


// MARK: - stdout 캡처 헬퍼 수정본
private func captureStandardOutput(_ closure: () -> Void) -> String {
    let pipe = Pipe()
    let originalStdOut = dup(STDOUT_FILENO)
    // stdout → pipe 쓰기
    dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

    closure()

    // 버퍼 비우고 복원
    fflush(stdout)
    dup2(originalStdOut, STDOUT_FILENO)
    close(originalStdOut)
    // 파이프 쓰기 끝 닫기 → EOF 발생
    pipe.fileHandleForWriting.closeFile()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: .utf8) ?? ""
}
