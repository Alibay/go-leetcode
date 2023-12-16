package go_leetcode

import (
	"github.com/stretchr/testify/suite"
	"testing"
)

type testSuite struct {
	suite.Suite
}

func TestProblems(t *testing.T) {
	suite.Run(t, new(testSuite))
}
