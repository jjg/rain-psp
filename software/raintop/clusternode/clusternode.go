package clusternode

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"

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

	// Load
	// TODO: Get this directly from /proc/loadavg instead
	// of using another package just for this.
	// TODO: Calculate this as a percentage (need to get
	// the cpu/core count and divide the overall load.
	l, err := load.Avg()
	if err != nil {
		fmt.Fprintf(os.Stderr, "%s\n", err)
		c.SetLoad(0.0)
	} else {
		c.SetLoad(l.Load1)
	}

	// Memory
	// /proc/meminfo
	meminfoFile, err := os.Open("/proc/meminfo")
	if err != nil {
		fmt.Fprintf(os.Stderr, "%s\n", err)
	}

	defer meminfoFile.Close()

	meminfoScanner := bufio.NewScanner(meminfoFile)

	// TODO: Improve this, it's silly right now
	// The first two lines of /proc/meminfo have
	// the values we need, so we can just read them
	// out one at a time, but there's probably a
	// more flexible/elegant solution to this.
	meminfoScanner.Scan()
	// MemTotal:       32718804 kB
	memTotalLine := meminfoScanner.Text()
	i := strings.IndexRune(memTotalLine, ':')
	memTotalValue := strings.TrimSpace(strings.TrimRight(memTotalLine[i+1:], "kB"))

	meminfoScanner.Scan()
	// MemFree:        24852164 kB
	memFreeLine := meminfoScanner.Text()
	i = strings.IndexRune(memFreeLine, ':')
	memFreeValue := strings.TrimSpace(strings.TrimRight(memFreeLine[i+1:], "kB"))

	memTotalFloat, _ := strconv.ParseFloat(memTotalValue, 64)
	memFreeFloat, _ := strconv.ParseFloat(memFreeValue, 64)

	// Calculate the percentage used
	memPercentUsed := (memTotalFloat - memFreeFloat) / memTotalFloat

	c.SetMem(memPercentUsed)

	// TODO: Temp
	// TODO: Temp should be a percentage of maximum safe temperature.
	t := 0.0
	c.SetTemp(t)
}

// Load setter.
func (c *ClusterNode) SetLoad(v float64) {
	c.Load = v

	// Add new value to end of Hist, shift the rest left.
	c.History[0] = append(c.History[0][1:c.HistoryLength], v)
}

// Mem setter.
func (c *ClusterNode) SetMem(v float64) {
	c.Mem = v

	// Add new value to end of Hist, shift the rest left.
	c.History[1] = append(c.History[1][1:c.HistoryLength], v)
}

// Temp setter.
func (c *ClusterNode) SetTemp(v float64) {
	c.Temp = v

	// Add new value to end of Hist, shift the rest left.
	c.History[2] = append(c.History[2][1:c.HistoryLength], v)
}
