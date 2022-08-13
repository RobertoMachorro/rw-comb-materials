import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "collect") {
	["A", "B", "C", "D", "E"].publisher
		//.collect()
		.collect(2)
		.sink(receiveCompletion: { print($0) },
			  receiveValue: { print($0) })
		.store(in: &subscriptions)
}

example(of: "map") {
	let formatter = NumberFormatter()
	formatter.numberStyle = .spellOut

	[123, 4, 56].publisher
		.map {
			formatter.string(for: NSNumber(integerLiteral: $0)) ?? ""
		}
		.sink(receiveValue: { print($0) })
		.store(in: &subscriptions)
}

example(of: "mapping key paths") {
	let publisher = PassthroughSubject<Coordinate, Never>()
	
	publisher
		.map(\.x, \.y)
		.sink(receiveValue: { x, y in
			print(
				"The coordinate at (\(x), \(y)) is in quadrant",
				quadrantOf(x: x, y: y)
			)
		})
		.store(in: &subscriptions)

	publisher.send(Coordinate(x: 10, y: -8))
	publisher.send(Coordinate(x: 0, y: 5))
}

example(of: "tryMap") {
	Just("Directory name that does not exist")
		.tryMap { try FileManager.default.contentsOfDirectory(atPath: $0) }
		.sink(receiveCompletion: { print($0) },
			  receiveValue: { print($0) })
		.store(in: &subscriptions)
}

/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
