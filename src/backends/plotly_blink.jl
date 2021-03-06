
# override some methods to use Plotlyjs/Blink

import Plotlyjs

function _create_plot(pkg::PlotlyPackage; kw...)
    d = Dict(kw)
    # TODO: create the window/canvas/context that is the plot within the backend (call it `o`)
    # TODO: initialize the plot... title, xlabel, bgcolor, etc
    o = Plotlyjs.Plot()

    Plot(o, pkg, 0, d, Dict[])
end


function _add_series(::PlotlyPackage, plt::Plot; kw...)
    d = Dict(kw)

    # add to the data array
    pdict = plotly_series(d)
    gt = Plotlyjs.GenericTrace(pdict[:type], pdict)
    push!(plt.o.data, gt)
    if !isnull(plt.o.window)
        Plotlyjs.addtraces!(plt.o, gt)
    end

    push!(plt.seriesargs, d)
    plt
end

# TODO: override this to update plot items (title, xlabel, etc) after creation
function _update_plot(plt::Plot{PlotlyPackage}, d::Dict)
    pdict = plotly_layout(d)
    plt.o.layout = Plotlyjs.Layout(pdict)
    if !isnull(plt.o.window)
        Plotlyjs.relayout!(plt.o, pdict...)
    end
end


function Base.display(::PlotsDisplay, plt::Plot{PlotlyPackage})
    dump(plt.o)
    show(plt.o)
end

function Base.display(::PlotsDisplay, plt::Subplot{PlotlyPackage})
    error()    
end
