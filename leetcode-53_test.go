package go_leetcode

func (t *testSuite) Test_53_SingleElement() {
	result := maxSubArray([]int{1})
	t.Equal(1, result)
}

func (t *testSuite) Test_53_AllNegative() {
	result := maxSubArray([]int{-3, -4, -2, -5})
	t.Equal(-2, result)
}

func (t *testSuite) Test_53_Random() {
	result := maxSubArray([]int{-2, 1, -3, 4, -1, 2, 1, -5, 4})
	t.Equal(6, result)
}
