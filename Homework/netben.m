function [ nb ] = netben(e, a, p, Qless, Qmore, t, growth)

    nb(1) = integral(@(qvalue) ((qvalue*(1+growth)^t)/a(1)).^(1/e(1)) - p(1), Qless(1), Qmore(1));
    nb(2) = integral(@(qvalue) ((qvalue*(1+growth)^t)/a(2)).^(1/e(2)) - p(2), Qless(2), Qmore(2));
    nb(3) = integral(@(qvalue) (qvalue/a(3)).^(1/e(3)) - p(3), Qless(3), Qmore(3));
    nb(4) = integral(@(qvalue) (qvalue/a(4)).^(1/e(4)) - p(4), Qless(4), Qmore(4));
    nb(5) = nb(1)+nb(2)+nb(3)+nb(4);
    
end

