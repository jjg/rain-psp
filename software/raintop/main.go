package main

import (
	"log"
	"time"

	"raintop/clusternode"

	ui "github.com/gizak/termui/v3"
	"github.com/gizak/termui/v3/widgets"
)

func main() {
	if err := ui.Init(); err != nil {
		log.Fatalf("failed to initialize termui: %v", err)
	}
	defer ui.Close()

	// Create an instance of ClusterNode for each node
	// TODO: Repeat for each node in the cluster.
	node0 := clusternode.New("rain-psp-0")

	// Use ClusterNode instances to assign values to UI elements.
	node0HistoryPlot := widgets.NewPlot()
	node0HistoryPlot.Title = node0.Host
	node0HistoryPlot.MaxVal = 4 // TODO: Change this to 1 when load is a percentage.
	node0HistoryPlot.Data = node0.History
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

			// Fetch updated stats for each node
			node0.Update()

			// Update the UI widget for each counter, node.
			node0HistoryPlot.Data = node0.History

			// Redraw with updated data.
			ui.Render(grid)
		}
	}
}
