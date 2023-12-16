package go_leetcode

type ordered interface {
	int | float32 | float64 | ~string
}

func max[T ordered](x T, y ...T) T {
	result := x

	for _, n := range y {
		if n > result {
			result = n
		}
	}

	return result
}

func min[T ordered](x T, y ...T) T {
	result := x

	for _, n := range y {
		if n < result {
			result = n
		}
	}

	return result
}
