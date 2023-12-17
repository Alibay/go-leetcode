package go_leetcode

func (t *testSuite) Test_867_EmptyList() {
	result := middleNode(nil)
	t.Nil(result)
}

func (t *testSuite) Test_867_SingleNode() {
	node := &ListNode{
		Val:  1,
		Next: nil,
	}
	result := middleNode(node)
	t.Equal(node, result)
}

func (t *testSuite) Test_867_OddNodes() {
	nodes := []*ListNode{
		{
			Val:  1,
			Next: nil,
		},
		{
			Val:  2,
			Next: nil,
		},
		{
			Val:  3,
			Next: nil,
		},
		{
			Val:  4,
			Next: nil,
		},
		{
			Val:  5,
			Next: nil,
		},
	}
	for i := 0; i < len(nodes)-1; i++ {
		nodes[i].Next = nodes[i+1]
	}

	result := middleNode(nodes[0])
	t.Equal(nodes[2], result)
}

func (t *testSuite) Test_867_EvenNodes() {
	nodes := []*ListNode{
		{
			Val:  1,
			Next: nil,
		},
		{
			Val:  2,
			Next: nil,
		},
		{
			Val:  3,
			Next: nil,
		},
		{
			Val:  4,
			Next: nil,
		},
		{
			Val:  5,
			Next: nil,
		},
		{
			Val:  6,
			Next: nil,
		},
	}
	for i := 0; i < len(nodes)-1; i++ {
		nodes[i].Next = nodes[i+1]
	}

	result := middleNode(nodes[0])
	t.Equal(nodes[3], result)
}
