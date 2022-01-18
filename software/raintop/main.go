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

	// Create an instance of ClusterNode for each physical node.
	nodes := make([]*clusternode.ClusterNode, 1)
	nodes[0] = clusternode.New("rain-psp-0")

	// For additional nodes, use append():
	//nodes = append(nodes, clusternode.New("rain-psp-x"))

	// Initialize plot charts
	historyPlots := make([]*widgets.Plot, len(nodes))
	for idx, node := range nodes {

		// Use ClusterNode instances to assign values to UI elements.
		historyPlot := widgets.NewPlot()
		historyPlot.Title = node.Host
		historyPlot.MaxVal = 1
		historyPlot.Data = node.History
		historyPlot.LineColors[0] = ui.ColorBlue
		historyPlot.LineColors[1] = ui.ColorYellow
		historyPlot.LineColors[2] = ui.ColorRed

		historyPlots[idx] = historyPlot
	}
	grid := ui.NewGrid()
	termWidth, termHeight := ui.TerminalDimensions()
	grid.SetRect(0, 0, termWidth, termHeight)

	// Creates a grid to contain all the gauges.
	// TODO: Add all gauges dynamically (not just one hard-coded as below).
	grid.Set(
		ui.NewRow(1.0/1,
			ui.NewCol(1.0/1, historyPlots[0]),
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
			for _, node := range nodes {
				node.Update()
			}

			// Update the UI widget for each counter, node.
			for idx, historyPlot := range historyPlots {
				historyPlot.Data = nodes[idx].History
			}

			// Redraw with updated data.
			ui.Render(grid)
		}
	}
}
