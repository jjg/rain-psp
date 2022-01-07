package main

import (
	"log"
	"math/rand"
	"time"

	"github.com/shirou/gopsutil/load"

	ui "github.com/gizak/termui/v3"
	"github.com/gizak/termui/v3/widgets"
)

// TODO: Create a routine that fetches performance data and
// updates internal data sources (arrays).
func getLoad() float64 {

	l, _ := load.Avg() //rand.Float64()

	return l.Load1
}

type ClusterNode struct {
	host    string
	load    float64
	mem     float64
	temp    float64
	history [][]float64
}

// TODO: In each of these setters, use a variable instead
// of hard-coded 49 in slice spec.
// Load setter.
func (c *ClusterNode) SetLoad(v float64) {
	c.load = v

	// Add new value to end of Hist, shift the rest left.
	c.history[0] = append(c.history[0][1:49], v)
}

// Mem setter.
func (c *ClusterNode) SetMem(v float64) {
	c.mem = v

	// Add new value to end of Hist, shift the rest left.
	c.history[1] = append(c.history[1][1:49], v)
}

// Temp setter.
func (c *ClusterNode) SetTemp(v float64) {
	c.temp = v

	// Add new value to end of Hist, shift the rest left.
	c.history[2] = append(c.history[2][1:49], v)
}

// Cluster factory.
func NewClusterNode(host string) *ClusterNode {
	p := new(ClusterNode)
	p.host = host
	p.history = make([][]float64, 3)

	// TODO: I don't know how to initialize this so that the X
	// scale is fixed (it changes with grid size).  Find a way
	// to make this work with different grid sizes.
	historyLength := 50
	p.history[0] = make([]float64, historyLength)
	p.history[1] = make([]float64, historyLength)
	p.history[2] = make([]float64, historyLength)

	return p
}

func main() {
	if err := ui.Init(); err != nil {
		log.Fatalf("failed to initialize termui: %v", err)
	}
	defer ui.Close()

	rand.Seed(time.Now().UnixNano())

	// Create an instance of ClusterNode for each node
	// TODO: Repeat for each node in the cluster.
	node0 := NewClusterNode("rain-psp-0")

	// Use ClusterNode instances to assign values to UI elements.
	node0HistoryPlot := widgets.NewPlot()
	node0HistoryPlot.Title = node0.host
	node0HistoryPlot.MaxVal = 1
	node0HistoryPlot.Data = node0.history
	node0HistoryPlot.LineColors[0] = ui.ColorBlue
	node0HistoryPlot.LineColors[1] = ui.ColorYellow
	node0HistoryPlot.LineColors[2] = ui.ColorRed

	grid := ui.NewGrid()
	termWidth, termHeight := ui.TerminalDimensions()
	grid.SetRect(0, 0, termWidth, termHeight)

	// Creates a grid to contain all the gauges.
	grid.Set(
		ui.NewRow(1.0/1,
			ui.NewCol(1.0/1, node0HistoryPlot),
		),
		// TODO: Repeat for each node in the cluster.
	)

	ui.Render(grid)

	// Update periodically.
	uiEvents := ui.PollEvents()
	ticker := time.NewTicker(time.Second).C

	for {
		select {
		case e := <-uiEvents:
			switch e.ID {
			case "q", "<C-c>": // 'q' or 'ctrl-c' to quit
				return
			case "<Resize>":
				//payload := e.Payload.(ui.Resize)
				//width, height := payload.Width, payload.Height
				// TODO: Actually resize the grid.
			}
			switch e.Type {
			case ui.KeyboardEvent: // all other keys
				//eventID = e.ID
			}
		case <-ticker: // Update the display each period.

			// TODO: This just hard-codes some data, but
			// eventually the "SetXYZ()" methods will be
			// called by a co-routine fetching actual
			// data from the cluster nodes.a
			node0.SetLoad(getLoad())
			node0.SetMem(0.0)
			node0.SetTemp(0.0)
			//node0Load.Title = fmt.Sprintf("load: %v", node0.load)

			// Update the UI widget for each counter, node.
			node0HistoryPlot.Data = node0.history

			// Redraw with updated data.
			ui.Render(grid)
		}
	}
}
