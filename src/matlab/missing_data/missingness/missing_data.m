function [ D_miss, Dt_miss, Dv_miss, M_mcar, Mt_mcar, Mv_mcar ] = ...
                missing_data( miss_type, miss_meth, miss_perc, D, Dt, Dv, F, T )
%MISSING_DATA Summary of this function goes here
%   Detailed explanation goes here
    switch(miss_type)
        case 'mcar'
            [D_miss, Dt_miss, Dv_miss, M_mcar, Mt_mcar, Mv_mcar] = ...
                                    mcar(miss_meth, miss_perc, D, Dt, Dv);
        case 'mar'
            [D_miss, Dt_miss, Dv_miss, M_mcar, Mt_mcar, Mv_mcar] = ...
                                    mar(miss_meth, miss_perc, D, Dt, Dv, F, T);
        case 'mnar'
    end

end

