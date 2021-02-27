import Foundation

extension Sequence {
    public func sum<T: Numeric>() -> T? where Element == Optional<T> {
        var result: T? = nil
        forEach { item in
            if let reduced = result, let new = item {
                result = reduced + new
            } else {
                if let new = item {
                    result = new
                }
            }
        }
        return result
    }
}


[nil, 1, 3.4].sum()
[1, 2].sum()
[nil, 1, 2].sum()
[0.1, nil].sum()

