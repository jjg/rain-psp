package main

import (
	"fmt"
	"log"
	"math/rand"
	"time"

	ui "github.com/gizak/termui/v3"
	"github.com/gizak/termui/v3/widgets"
)

type ClusterNode struct {
	host     string
	load     float64
	mem      float64
	temp     float64
	loadHist [][]float64
	memHist  []float64
	tempHist []float64
}

// Load setter.
func (c *ClusterNode) SetLoad(v float64) {
	c.load = v

	// Add new value to end of loadHist, shift the rest left.
	c.loadHist[0] = append(c.loadHist[0][1:49], v)

	//loadHistAxisOne := [1]float64{v} //append(c.loadHist[1:9], v)
	//axisOne := make([]float64, 1)
	//axisOne[0] = v

	//c.loadHist = append(c.loadHist[1:9], axisOne)
}

// Cluster factory.
func NewClusterNode() *ClusterNode {
	p := new(ClusterNode)
	//p.loadHist = [][]float64{[]float64{0.1, 0.3, 0.2, 0.6, 0.4, 0.2, 0.4, 0.5, 0.9, 0.3}}

	p.loadHist = make([][]float64, 1)
	p.loadHist[0] = make([]float64, 50)

	//p.loadHist[0] = append(p.loadHist[0], 0.8)

	return p
}

// TODO: Create a routine that fetches performance data and
// updates internal data sources (arrays).

func main() {
	if err := ui.Init(); err != nil {
		log.Fatalf("failed to initialize termui: %v", err)
	}
	defer ui.Close()

	rand.Seed(time.Now().UnixNano())

	// Create an instance of ClusterNode for each node
	node0 := NewClusterNode()

	// Use ClusterNode instances to assign values to UI elements.
	//node0Load := widgets.NewSparkline()
	node0Load := widgets.NewPlot()
	node0Load.Title = fmt.Sprintf("load: %v", node0.load)
	//node0Load.Marker = widgets.MarkerDot
	node0Load.Data = node0.loadHist
	//node0Load.SetRect(50, 0, 75, 10)
	node0Load.LineColors[0] = ui.ColorBlue
	/*
		node0Mem := widgets.NewSparkline()
		node0Mem.Title = "mem"
		node0Mem.Data = node0.memHist
		node0Mem.LineColors[0] = ui.ColorYellow

		node0Temp := widgets.NewSparkline()
		node0Temp.Title = "temp"
		node0Temp.Data = node0.tempHist
		node0Temp.LineColors[0] = ui.ColorRed
	*/
	//node0Group := widgets.NewSparklineGroup(node0Load, node0Mem, node0Temp)
	//node0Group.Title = "rain-psp-0"
	//node0Group.SetRect(0, 0, 20, 20)
	// TODO: Repeat for each node in the cluster.

	grid := ui.NewGrid()
	termWidth, termHeight := ui.TerminalDimensions()
	grid.SetRect(0, 0, termWidth, termHeight)

	// Creates a grid to contain all the gauges.
	grid.Set(
		ui.NewRow(1.0/4,
			ui.NewCol(1.0/1, node0Load),
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
			node0.SetLoad(rand.Float64())
			node0Load.Title = fmt.Sprintf("load: %v", node0.load)

			// Update the UI widget for each counter, node.
			node0Load.Data = node0.loadHist

			// Redraw with updated data.
			ui.Render(grid)
		}
	}
}
