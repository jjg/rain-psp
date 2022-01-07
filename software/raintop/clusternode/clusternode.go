package clusternode

import (
	"github.com/shirou/gopsutil/load"
)

type ClusterNode struct {
	Host          string
	Load          float64
	Mem           float64
	Temp          float64
	History       [][]float64
	HistoryLength int
}

// Cluster factory.
func New(host string) *ClusterNode {
	p := new(ClusterNode)
	p.Host = host
	p.History = make([][]float64, 3)

	// TODO: I don't know how to initialize this so that the X
	// scale is fixed (it changes with grid size).  Find a way
	// to make this work with different grid sizes.
	p.HistoryLength = 50
	p.History[0] = make([]float64, p.HistoryLength)
	p.History[1] = make([]float64, p.HistoryLength)
	p.History[2] = make([]float64, p.HistoryLength)

	return p
}

func (c *ClusterNode) Update() {

	// TODO: Get the load, mem and temp
	// TODO: Eventually this will use the host property
	// to fetch this info from the remote node.
	l, _ := load.Avg()
	m := 0.5
	t := 0.3

	// Set the load, mem and temp
	c.SetLoad(l.Load1)
	c.SetMem(m)
	c.SetTemp(t)
}

// Load setter.
func (c *ClusterNode) SetLoad(v float64) {
	c.Load = v

	// Add new value to end of Hist, shift the rest left.
	c.History[0] = append(c.History[0][1:c.HistoryLength-1], v)
}

// Mem setter.
func (c *ClusterNode) SetMem(v float64) {
	c.Mem = v

	// Add new value to end of Hist, shift the rest left.
	c.History[1] = append(c.History[1][1:c.HistoryLength-1], v)
}

// Temp setter.
func (c *ClusterNode) SetTemp(v float64) {
	c.Temp = v

	// Add new value to end of Hist, shift the rest left.
	c.History[2] = append(c.History[2][1:c.HistoryLength-1], v)
}
