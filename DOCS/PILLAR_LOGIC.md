# Ross Cameron 5-Pillar Grading Logic

This document defines the algorithmic weights for the stock grading system.

## Grading Thresholds
### Grade A (The Perfect Setup)
- **Catalyst:** Strong/Active (Earnings, FDA, Breaking News).
- **Float:** < 10M shares.
- **Daily Chart:** Clean, no resistance for 20%+.
- **RVOL (Relative Volume):** > 3.0.
- **Risk/Reward:** > 3:1.

### Grade B (Strong Trade)
- **Catalyst:** Moderate (Sector momentum, Sympathy play).
- **Float:** 10M - 50M shares.
- **Daily Chart:** Some minor resistance levels nearby.
- **RVOL:** 1.5 - 3.0.
- **Risk/Reward:** 2:1.

### Grade C/D (Low Probability)
- **Catalyst:** None or Weak.
- **Float:** > 50M (High float).
- **RVOL:** < 1.0.
- **Risk/Reward:** < 1:1.

## Calculation Logic
The overall grade is the average of these 5 pillars. If "Float" is > 100M, the maximum possible grade is "C" regardless of other pillars.
