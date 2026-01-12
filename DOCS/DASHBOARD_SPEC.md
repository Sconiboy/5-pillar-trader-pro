# Dashboard Technical Specification

## Core Components
1. **Header:** Quick Search bar + Market Status (Open/Closed).
2. **Scan List:** A scrolling list of stocks.
3. **Data Points per Row:**
   - Symbol (Bold, left)
   - Price & % Change (Below symbol)
   - Pillar Grade Badge (Large, right-aligned)
   - Sparkline (Center, showing 1-hour trend)

## Interactions
- **Tap Stock:** Navigate to `AnalysisDetailScreen`.
- **Long Press:** Add to Watchlist.
- **Pull to Refresh:** Trigger a new API scan.

## State Management
The dashboard should update every 30 seconds for price data.
