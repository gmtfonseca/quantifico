export const PlotState = Object.freeze({
  LOADING: 0,
  READY: 1,
  EMPTY: 2,
  ERROR: 3
})

export default class {
  constructor() {
    this._state = PlotState.LOADING
    this._params = {}
    this._series = []
  }

  async build() {
    try {
      this._state = PlotState.LOADING
      this._series = await this.getSeries(this._params)
      this._state = PlotState.READY
    } catch (e) {
      this._state = PlotState.ERROR
      console.log(e)
    }
  }

  async getSeries() {}

  get state() {
    return this._state
  }

  get series() {
    return this._series
  }

  get empty() {
    return !this.series.length || !this.series[0].data.length
  }

  get params() {
    return this._params
  }

  set params(params) {
    this._params = params
    this.build()
  }
}
