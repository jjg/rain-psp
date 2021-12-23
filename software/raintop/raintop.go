package main

import (
	"log"
	"time"

	ui "github.com/gizak/termui/v3"
	"github.com/gizak/termui/v3/widgets"
)

func redraw(grid *ui.Grid, node0Load *widgets.Sparkline, data []float64, dataIdx int) {
	node0Load.Data = data[dataIdx:]
	ui.Render(grid)
}

func main() {
	if err := ui.Init(); err != nil {
		log.Fatalf("failed to initialize termui: %v", err)
	}
	defer ui.Close()

	data := []float64{4, 2, 1, 6, 3, 9, 1, 4, 15, 20, 1, 3}
	dataIdx := 0

	node0Load := widgets.NewSparkline()
	node0Load.Title = "load"
	node0Load.Data = data[dataIdx:]
	node0Load.LineColor = ui.ColorBlue

	node0Mem := widgets.NewSparkline()
	node0Mem.Title = "mem"
	node0Mem.Data = data[dataIdx:]
	node0Mem.LineColor = ui.ColorYellow

	node0Temp := widgets.NewSparkline()
	node0Temp.Title = "temp"
	node0Temp.Data = data[dataIdx:]
	node0Temp.LineColor = ui.ColorRed

	node0Group := widgets.NewSparklineGroup(node0Load, node0Mem, node0Temp)
	node0Group.Title = "rain-psp-0"
	//node0Group.SetRect(0, 0, 20, 20)

	node1Group := widgets.NewSparklineGroup(node0Load, node0Mem, node0Temp)
	node1Group.Title = "rain-psp-1"

	node2Group := widgets.NewSparklineGroup(node0Load, node0Mem, node0Temp)
	node2Group.Title = "rain-psp-2"

	node3Group := widgets.NewSparklineGroup(node0Load, node0Mem, node0Temp)
	node3Group.Title = "rain-psp-3"

	node4Group := widgets.NewSparklineGroup(node0Load, node0Mem, node0Temp)
	node4Group.Title = "rain-psp-4"

	node5Group := widgets.NewSparklineGroup(node0Load, node0Mem, node0Temp)
	node5Group.Title = "rain-psp-5"

	node6Group := widgets.NewSparklineGroup(node0Load, node0Mem, node0Temp)
	node6Group.Title = "rain-psp-6"

	grid := ui.NewGrid()
	termWidth, termHeight := ui.TerminalDimensions()
	grid.SetRect(0, 0, termWidth, termHeight)

	// Creates a grid to contain all the gauges.
	grid.Set(
		ui.NewRow(1.0/7,
			ui.NewCol(1.0/1, node0Group),
		),
		ui.NewRow(1.0/7,
			ui.NewCol(1.0/1, node1Group),
		),
		ui.NewRow(1.0/7,
			ui.NewCol(1.0/1, node2Group),
		),
		ui.NewRow(1.0/7,
			ui.NewCol(1.0/1, node3Group),
		),
		ui.NewRow(1.0/7,
			ui.NewCol(1.0/1, node4Group),
		),
		ui.NewRow(1.0/7,
			ui.NewCol(1.0/1, node5Group),
		),
		ui.NewRow(1.0/7,
			ui.NewCol(1.0/1, node6Group),
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
			// finally update on a schedule
		case <-ticker:
			dataIdx++
			redraw(grid, node0Load, data, dataIdx)
		}
	}
}
