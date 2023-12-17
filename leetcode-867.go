package go_leetcode

type ListNode struct {
	Val  int
	Next *ListNode
}

/*
* 	876. Middle of the Linked List (EASY)
*	Given the head of a singly linked list, return the middle node of the linked list.
*	If there are two middle nodes, return the second middle node.
 */
func middleNode(head *ListNode) *ListNode {
	fast := head
	slow := head

	for fast != nil && fast.Next != nil {
		slow = slow.Next
		fast = fast.Next.Next
	}

	return slow
}
