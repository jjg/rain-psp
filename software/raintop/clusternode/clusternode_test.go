package clusternode

import (
	"fmt"
	"testing"
)

func TestClusterFactory(t *testing.T) {
	cases := []struct {
		in, want string
	}{
		{"node0.local", "node0.local"},
	}
	for _, c := range cases {
		got := New(c.in)

		// Show results of initialization.
		fmt.Printf("ClusterNode type: %T\n", got)
		fmt.Printf("Load: %v\n", got.Load)
		fmt.Printf("Mem: %v\n", got.Mem)
		fmt.Printf("Temp: %v\n", got.Temp)
		fmt.Printf("History type: %T\n", got.History)
		fmt.Printf("History array length: %v\n", len(got.History))
		fmt.Printf("HistoryLength: %v\n", got.HistoryLength)

		// Check hostname initializaiton.
		if got.Host != c.want {
			t.Errorf("New(%q) == %q, want %q", c.in, got.Host, c.want)
		}
	}
}

func TestUpdate(t *testing.T) {
	node := New("host0.local")
	node.Update()

	fmt.Printf("Load: %v\n", node.Load)
	fmt.Printf("Mem: %v\n", node.Mem)
	fmt.Printf("Temp: %v\n", node.Temp)
	fmt.Printf("Load history value: %v\n", node.History[0][node.HistoryLength-1])

	if node.Load == 0 {
		t.Errorf("Load == 0, want > 0")
	}
	if node.Mem == 0 {
		t.Errorf("Mem ==0, want > 0")
	}
	/*
		if node.Temp == 0 {
			t.Errorf("Temp == 0, want > 0")
		}
	*/

}
