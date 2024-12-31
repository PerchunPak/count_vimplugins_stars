import gleam/int
import gleam/io
import gleam/list

pub fn print_results(results: List(Int)) -> Nil {
  let over10k = int.to_string(list.count(results, fn(x) { x > 10_000 }))
  let over1k =
    int.to_string(list.count(results, fn(x) { x > 1000 && x < 10_000 }))
  let over1k_ = int.to_string(list.count(results, fn(x) { x > 1000 }))
  let over100 =
    int.to_string(list.count(results, fn(x) { x > 100 && x < 1000 }))
  let over100_ = int.to_string(list.count(results, fn(x) { x > 100 }))
  let over10 = int.to_string(list.count(results, fn(x) { x > 10 && x < 100 }))
  let over10_ = int.to_string(list.count(results, fn(x) { x > 10 }))
  let other = int.to_string(list.count(results, fn(x) { x < 10 }))

  io.println("over 10k: " <> over10k)
  io.println("over 1k : " <> over1k <> " (" <> over1k_ <> ")")
  io.println("over 100: " <> over100 <> " (" <> over100_ <> ")")
  io.println("over 10 : " <> over10 <> " (" <> over10_ <> ")")
  io.println("other   : " <> other)
  io.println("total   : " <> int.to_string(list.length(results)))
}
