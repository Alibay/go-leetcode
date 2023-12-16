package go_leetcode

func maxSubArray(nums []int) int {
	result := nums[0]
	current := 0
	for _, num := range nums {
		current = max(current, 0)
		current = current + num
		result = max(result, current)
	}
	return result
}

func myMax(a, b int) int {
	if a > b {
		return a
	} else {
		return b
	}
}
