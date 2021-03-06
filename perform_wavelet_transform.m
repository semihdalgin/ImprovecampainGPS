function y = perform_wavelet_transform(x, Jmin, dir, options)

if nargin<3
    dir = 1;
end
if nargin<2
    Jmin = 3;
end

options.null = 0;
wavelet_type = getoptions(options, 'wavelet_type', 'daubechies');
VM = getoptions(options, 'wavelet_vm', 4);
ti = getoptions(options, 'ti', 0);

ndim = nb_dims(x);

if ndim==3 && size(x,3)<=4
    y = x;
    for i=1:size(x,3)
        y(:,:,i) = perform_wavelet_transform(x(:,:,i), Jmin, dir, options);
    end
    return;
end

switch lower(wavelet_type)
    case 'daubechies'
        qmf = MakeONFilter('Daubechies',VM*2); 
    case 'haar'
        qmf = MakeONFilter('Haar');  
    case 'symmlet'
        qmf = MakeONFilter('Symmlet',VM);
    case 'battle'
        qmf = MakeONFilter('Battle',VM-1);
        dqmf = qmf; 
    case 'biorthogonal'
        [qmf,dqmf] = MakeBSFilter( 'CDF', [VM,VM] );
    case 'biorthogonal_swapped'
        [dqmf,qmf] = MakeBSFilter( 'CDF', [VM,VM] );
    otherwise
        error('Unknown transform.');
end

if ti
    if dir==-1
        ndim=ndim-1;
    end        
    if ndim==2 && size(x,2)<50
        ndim = 1;
    end
    if ndim==1
        if dir==1
            y = TI2Stat( FWT_TI(x,Jmin,qmf) );
        else
            y = IWT_TI( Stat2TI(x),qmf);
            y = y(:);
        end
    elseif ndim==2
        if dir==1
            y = FWT2_TI(x,Jmin,qmf);
            n = size(f,1);
            y = reshape( y, [n size(y,1)/n n] );
            y = permute(y, [1 3 2]);
        else
            x = permute(x, [1 3 2]);
            x = reshape( x, [size(x,1)*size(x,2) size(x,3)] );
            y = IWT2_TI(x,Jmin,qmf);
        end
    end
    return;
end

if ~exist('dqmf')
    if ndim==1
        if dir==1
            y = FWT_PO(x,Jmin,qmf);
        else
            y = IWT_PO(x,Jmin,qmf);
        end
    elseif ndim==2
        if dir==1
            y = FWT2_PO(x,Jmin,qmf);
        else
            y = IWT2_PO(x,Jmin,qmf);
        end
    end
else
    if ndim==1
        if dir==1
            y = FWT_SBS(x,Jmin,qmf,dqmf);
        else
            y = IWT_SBS(x,Jmin,qmf,dqmf);
        end
    elseif ndim==2
        if dir==1
            y = FWT2_SBS(x,Jmin,qmf,dqmf);
        else
            y = IWT2_SBS(x,Jmin,qmf,dqmf);
        end
    end
end



function f = MakeONFilter(Type,Par)

if strcmp(Type,'Haar'),
    f = [1 1] ./ sqrt(2);
end

if strcmp(Type,'Beylkin'),
    f = [	.099305765374	.424215360813	.699825214057	...
        .449718251149	-.110927598348	-.264497231446	...
        .026900308804	.155538731877	-.017520746267	...
        -.088543630623	.019679866044	.042916387274	...
        -.017460408696	-.014365807969	.010040411845	...
        .001484234782	-.002736031626	.000640485329	];
end

if strcmp(Type,'Coiflet'),
    if Par==1,
        f = [	.038580777748	-.126969125396	-.077161555496	...
            .607491641386	.745687558934	.226584265197	];
    end
    if Par==2,
        f = [	.016387336463	-.041464936782	-.067372554722	...
            .386110066823	.812723635450	.417005184424	...
            -.076488599078	-.059434418646	.023680171947	...
            .005611434819	-.001823208871	-.000720549445	];
    end
    if Par==3,
        f = [	-.003793512864	.007782596426	.023452696142	...
            -.065771911281	-.061123390003	.405176902410	...
            .793777222626	.428483476378	-.071799821619	...
            -.082301927106	.034555027573	.015880544864	...
            -.009007976137	-.002574517688	.001117518771	...
            .000466216960	-.000070983303	-.000034599773	];
    end
    if Par==4,
        f = [	.000892313668	-.001629492013	-.007346166328	...
            .016068943964	.026682300156	-.081266699680	...
            -.056077313316	.415308407030	.782238930920	...
            .434386056491	-.066627474263	-.096220442034	...
            .039334427123	.025082261845	-.015211731527	...
            -.005658286686	.003751436157	.001266561929	...
            -.000589020757	-.000259974552	.000062339034	...
            .000031229876	-.000003259680	-.000001784985	];
    end
    if Par==5,
        f = [	-.000212080863	.000358589677	.002178236305	...
            -.004159358782	-.010131117538	.023408156762	...
            .028168029062	-.091920010549	-.052043163216	...
            .421566206729	.774289603740	.437991626228	...
            -.062035963906	-.105574208706	.041289208741	...
            .032683574283	-.019761779012	-.009164231153	...
            .006764185419	.002433373209	-.001662863769	...
            -.000638131296	.000302259520	.000140541149	...
            -.000041340484	-.000021315014	.000003734597	...
            .000002063806	-.000000167408	-.000000095158	];
    end
end

if strcmp(Type,'Daubechies'),
    if Par==4,
        f = [	.482962913145	.836516303738	...
            .224143868042	-.129409522551	];
    end
    if Par==6,
        f = [	.332670552950	.806891509311	...
            .459877502118	-.135011020010	...
            -.085441273882	.035226291882	];
    end
    if Par==8,
        f = [ 	.230377813309	.714846570553	...
            .630880767930	-.027983769417	...
            -.187034811719	.030841381836	...
            .032883011667	-.010597401785	];
    end
    if Par==10,
        f = [	.160102397974	.603829269797	.724308528438	...
            .138428145901	-.242294887066	-.032244869585	...
            .077571493840	-.006241490213	-.012580751999	...
            .003335725285									];
    end
    if Par==12,
        f = [	.111540743350	.494623890398	.751133908021	...
            .315250351709	-.226264693965	-.129766867567	...
            .097501605587	.027522865530	-.031582039317	...
            .000553842201	.004777257511	-.001077301085	];
    end
    if Par==14,
        f = [	.077852054085	.396539319482	.729132090846	...
            .469782287405	-.143906003929	-.224036184994	...
            .071309219267	.080612609151	-.038029936935	...
            -.016574541631	.012550998556	.000429577973	...
            -.001801640704	.000353713800					];
    end
    if Par==16,
        f = [	.054415842243	.312871590914	.675630736297	...
            .585354683654	-.015829105256	-.284015542962	...
            .000472484574	.128747426620	-.017369301002	...
            -.044088253931	.013981027917	.008746094047	...
            -.004870352993	-.000391740373	.000675449406	...
            -.000117476784									];
    end
    if Par==18,
        f = [	.038077947364	.243834674613	.604823123690	...
            .657288078051	.133197385825	-.293273783279	...
            -.096840783223	.148540749338	.030725681479	...
            -.067632829061	.000250947115	.022361662124	...
            -.004723204758	-.004281503682	.001847646883	...
            .000230385764	-.000251963189	.000039347320	];
    end
    if Par==20,
        f = [	.026670057901	.188176800078	.527201188932	...
            .688459039454	.281172343661	-.249846424327	...
            -.195946274377	.127369340336	.093057364604	...
            -.071394147166	-.029457536822	.033212674059	...
            .003606553567	-.010733175483	.001395351747	...
            .001992405295	-.000685856695	-.000116466855	...
            .000093588670	-.000013264203					];
    end
end

if strcmp(Type,'Symmlet'),
    if Par==4,
        f = [	-.107148901418	-.041910965125	.703739068656	...
            1.136658243408	.421234534204	-.140317624179	...
            -.017824701442	.045570345896					];
    end
    if Par==5,
        f = [	.038654795955	.041746864422	-.055344186117	...
            .281990696854	1.023052966894	.896581648380	...
            .023478923136	-.247951362613	-.029842499869	...
            .027632152958									];
    end
    if Par==6,
        f = [	.021784700327	.004936612372	-.166863215412	...
            -.068323121587	.694457972958	1.113892783926	...
            .477904371333	-.102724969862	-.029783751299	...
            .063250562660	.002499922093	-.011031867509	];
    end
    if Par==7,
        f = [	.003792658534	-.001481225915	-.017870431651	...
            .043155452582	.096014767936	-.070078291222	...
            .024665659489	.758162601964	1.085782709814	...
            .408183939725	-.198056706807	-.152463871896	...
            .005671342686	.014521394762					];
    end
    if Par==8,
        f = [	.002672793393	-.000428394300	-.021145686528	...
            .005386388754	.069490465911	-.038493521263	...
            -.073462508761	.515398670374	1.099106630537	...
            .680745347190	-.086653615406	-.202648655286	...
            .010758611751	.044823623042	-.000766690896	...
            -.004783458512									];
    end
    if Par==9,
        f = [	.001512487309	-.000669141509	-.014515578553	...
            .012528896242	.087791251554	-.025786445930	...
            -.270893783503	.049882830959	.873048407349	...
            1.015259790832	.337658923602	-.077172161097	...
            .000825140929	.042744433602	-.016303351226	...
            -.018769396836	.000876502539	.001981193736	];
    end
    if Par==10,
        f = [	.001089170447	.000135245020	-.012220642630	...
            -.002072363923	.064950924579	.016418869426	...
            -.225558972234	-.100240215031	.667071338154	...
            1.088251530500	.542813011213	-.050256540092	...
            -.045240772218	.070703567550	.008152816799	...
            -.028786231926	-.001137535314	.006495728375	...
            .000080661204	-.000649589896					];
    end
end

if strcmp(Type,'Vaidyanathan'),
    f = [	-.000062906118	.000343631905	-.000453956620	...
        -.000944897136	.002843834547	.000708137504	...
        -.008839103409	.003153847056	.019687215010	...
        -.014853448005	-.035470398607	.038742619293	...
        .055892523691	-.077709750902	-.083928884366	...
        .131971661417	.135084227129	-.194450471766	...
        -.263494802488	.201612161775	.635601059872	...
        .572797793211	.250184129505	.045799334111		];
end

if strcmp(Type,'Battle'),
    if Par == 1,
        g = [0.578163    0.280931   -0.0488618   -0.0367309 ...
            0.012003    0.00706442 -0.00274588 -0.00155701 ...
            0.000652922 0.000361781 -0.000158601 -0.0000867523
            ];
    end

    if Par == 3,

        g = [0.541736    0.30683    -0.035498    -0.0778079 ...
            0.0226846   0.0297468     -0.0121455 -0.0127154 ...
            0.00614143 0.00579932    -0.00307863 -0.00274529 ...
            0.00154624 0.00133086 -0.000780468 -0.00065562 ...
            0.000395946 0.000326749 -0.000201818 -0.000164264 ...
            0.000103307
            ];
    end

    if Par == 5,
        g = [0.528374    0.312869    -0.0261771   -0.0914068 ...
            0.0208414    0.0433544 -0.0148537 -0.0229951  ...
            0.00990635 0.0128754    -0.00639886 -0.00746848 ...
            0.00407882 0.00444002 -0.00258816    -0.00268646 ...
            0.00164132 0.00164659 -0.00104207 -0.00101912 ...
            0.000662836 0.000635563 -0.000422485 -0.000398759 ...
            0.000269842 0.000251419 -0.000172685 -0.000159168 ...
            0.000110709 0.000101113
            ];
    end
    l = length(g);
    f = zeros(1,2*l-1);
    f(l:2*l-1) = g;
    f(1:l-1) = reverse(g(2:l));
end

f = f ./ norm(f);


function wcoef = FWT_PO(x,L,qmf)

[n,J] = dyadlength(x) ;
wcoef = zeros(1,n) ;
beta = ShapeAsRow(x); 
for j=J-1:-1:L
    alfa = DownDyadHi(beta,qmf);
    wcoef(dyad(j)) = alfa;
    beta = DownDyadLo(beta,qmf) ;
end
wcoef(1:(2^L)) = beta;
wcoef = ShapeLike(wcoef,x);


function [n,J] = dyadlength(x)

n = length(x) ;
J = ceil(log(n)/log(2));
if 2^J ~= n ,
    disp('Warning in dyadlength: n != 2^J')
end



function row = ShapeAsRow(sig)

row = sig(:)';


function d = DownDyadHi(x,qmf)

d = iconv( MirrorFilt(qmf),lshift(x));
n = length(d);
d = d(1:2:(n-1));




function y = MirrorFilt(x)


y = -( (-1).^(1:length(x)) ).*x;


function y = lshift(x)


y = [ x( 2:length(x) ) x(1) ];


function y = iconv(f,x)

n = length(x);
p = length(f);
if p <= n,
    xpadded = [x((n+1-p):n) x];
else
    z = zeros(1,p);
    for i=1:p,
        imod = 1 + rem(p*n -p + i-1,n);
        z(i) = x(imod);
    end
    xpadded = [z x];
end
ypadded = filter(f,1,xpadded);
y = ypadded((p+1):(n+p));



function i = dyad(j)

i = (2^(j)+1):(2^(j+1)) ;


function d = DownDyadLo(x,qmf)

d = aconv(qmf,x);
n = length(d);
d = d(1:2:(n-1));


function y = aconv(f,x)

n = length(x);
p = length(f);
if p < n,
    xpadded = [x x(1:p)];
else
    z = zeros(1,p);
    for i=1:p,
        imod = 1 + rem(i-1,n);
        z(i) = x(imod);
    end
    xpadded = [x z];
end
fflip = reverse(f);
ypadded = filter(fflip,1,xpadded);
y = ypadded(p:(n+p-1));


function vec = ShapeLike(sig,proto)

sp = size(proto);
ss = size(sig);
if( sp(1)>1 & sp(2)>1 )
    disp('Weird proto argument to ShapeLike')
elseif ss(1)>1 & ss(2) > 1,
    disp('Weird sig argument to ShapeLike')
else
    if(sp(1) > 1),
        if ss(1) > 1,
            vec = sig;
        else
            vec = sig(:);
        end
    else
        if ss(2) > 1,
            vec = sig;
        else
            vec = sig(:)';
        end
    end
end




function x = IWT_PO(wc,L,qmf)

wcoef = ShapeAsRow(wc);
x = wcoef(1:2^L);
[n,J] = dyadlength(wcoef);
for j=L:J-1
    x = UpDyadLo(x,qmf) + UpDyadHi(wcoef(dyad(j)),qmf)  ;
end
x = ShapeLike(x,wc);



function y = UpDyadLo(x,qmf)

y =  iconv(qmf, UpSample(x) );



function y = UpSample(x,s)


if nargin == 1, s = 2; end
n = length(x)*s;
y = zeros(1,n);
y(1:s:(n-s+1) )=x;




function y = UpDyadHi(x,qmf)


y = aconv( MirrorFilt(qmf), rshift( UpSample(x) ) );


function y = rshift(x)


n = length(x);
y = [ x(n) x( 1: (n-1) )];




function [qmf,dqmf] = MakeBSFilter(Type,Par)


if nargin < 2,
    Par = 0;
end

sqr2 = sqrt(2);

if strcmp(Type,'Triangle'),
    qmf = [0 1 0];
    dqmf = [.5 1 .5];

elseif strcmp(Type,'Interpolating') | strcmp(Type,'Deslauriers'),
    qmf  = [0 1 0];
    dqmf = MakeDDFilter(Par)';
    dqmf =  dqmf(1:(length(dqmf)-1));

elseif strcmp(Type,'Average-Interpolating'),
    qmf  = [0 .5 .5] ;
    dqmf = [0 ; MakeAIFilter(Par)]';

elseif strcmp(Type,'CDF'),
    if Par(1)==1,
        dqmf = [0 .5 .5] .* sqr2;
        if Par(2) == 1,
            qmf = [0 .5 .5] .* sqr2;
        elseif Par(2) == 3,
            qmf = [0 -1 1 8 8 1 -1] .* sqr2 / 16;
        elseif Par(2) == 5,
            qmf = [0 3 -3 -22 22 128 128 22 -22 -3 3].*sqr2/256;
        end
    elseif Par(1)==2,
        dqmf = [.25 .5 .25] .* sqr2;
        if Par(2)==2,
            qmf = [-.125 .25 .75 .25 -.125] .* sqr2;
        elseif Par(2)==4,
            qmf = [3 -6 -16 38 90 38 -16 -6 3] .* (sqr2/128);
        elseif Par(2)==6,
            qmf = [-5 10 34 -78 -123 324 700 324 -123 -78 34 10 -5 ] .* (sqr2/1024);
        elseif Par(2)==8,
            qmf = [35 -70 -300 670 1228 -3126 -3796 10718 22050 ...
                10718 -3796 -3126 1228 670 -300 -70 35 ] .* (sqr2/32768);
        end
    elseif Par(1)==3,
        dqmf = [0 .125 .375 .375 .125] .* sqr2;
        if Par(2) == 1,
            qmf = [0 -.25 .75 .75 -.25] .* sqr2;
        elseif Par(2) == 3,
            qmf = [0 3 -9 -7 45 45 -7 -9 3] .* sqr2/64;
        elseif Par(2) == 5,
            qmf = [0 -5 15 19 -97 -26 350 350 -26 -97 19 15 -5] .* sqr2/512;
        elseif Par(2) == 7,
            qmf = [0 35 -105 -195 865 363 -3489 -307 11025 11025 -307 -3489 363 865 -195 -105 35] .* sqr2/16384;
        elseif Par(2) == 9,
            qmf = [0 -63 189 469 -1911 -1308 9188 1140 -29676 190 87318 87318 190 -29676 ...
                1140 9188 -1308 -1911 469 189 -63] .* sqr2/131072;
        end
    elseif Par(1)==4,
        dqmf = [.026748757411 -.016864118443 -.078223266529 .266864118443 .602949018236 ...
            .266864118443 -.078223266529 -.016864118443 .026748757411] .*sqr2;
        if Par(2) == 4,
            qmf = [0 -.045635881557 -.028771763114 .295635881557 .557543526229 ...
                .295635881557 -.028771763114 -.045635881557 0] .*sqr2;
        end
    end

elseif strcmp(Type,'Villasenor'),
    if Par == 1,
         qmf = [.037828455506995 -.023849465019380 -.11062440441842 .37740285561265];
        qmf = [qmf .85269867900940 reverse(qmf)];
        dqmf = [-.064538882628938 -.040689417609558 .41809227322221];
        dqmf = [dqmf .78848561640566 reverse(dqmf)];
    elseif Par == 2,
        qmf  = [-.008473 .003759 .047282 -.033475 -.068867 .383269 .767245 .383269 -.068867...
            -.033475 .047282 .003759 -.008473];
        dqmf = [0.014182  0.006292 -0.108737 -0.069163 0.448109 .832848 .448109 -.069163 -.108737 .006292 .014182];
    elseif Par == 3,
        qmf  = [0 -.129078 .047699 .788486 .788486 .047699 -.129078];
        dqmf = [0 .018914 .006989 -.067237 .133389 .615051 .615051 .133389 -.067237 .006989 .018914];
    elseif Par == 4,
        qmf  = [-1 2 6 2 -1] / (4*sqr2);
        dqmf = [1 2 1] / (2*sqr2);
    elseif Par == 5,
        qmf  = [0 1 1]/sqr2;
        dqmf = [0 -1 1 8 8 1 -1]/(8*sqr2);
    end
end



function wcoef = FWT_SBS(x,L,qmf,dqmf)

[n,J] = dyadlength(x);

wcoef = zeros(1,n);
beta = ShapeAsRow(x);  % take samples at finest scale as beta-coeffts

dp = dyadpartition(n);

for j=J-1:-1:L,
    [beta, alfa] = DownDyad_SBS(beta,qmf,dqmf);
    dyadj = (dp(j+1)+1):dp(j+2);
    wcoef(dyadj) = alfa;
end
wcoef(1:length(beta)) = beta;
wcoef = ShapeLike(wcoef,x);


function dp = dyadpartition(n)

J = ceil(log2(n));

m = n;
for j=J-1:-1:0;
    if rem(m,2)==0,
        dps(j+1) = m/2;
        m = m/2;
    else
        dps(j+1) = (m-1)/2;
        m = (m+1)/2;
    end
end

dp = cumsum([1 dps]);



function [beta, alpha] = DownDyad_SBS(x,qmf,dqmf)

oddf = ~(qmf(1)==0 & qmf(length(qmf))~=0);
oddx = (rem(length(x),2)==1);


if oddf,
    ex = extend(x,1,1);
else
    ex = extend(x,2,2);
end


ebeta = DownDyadLo_PBS(ex,qmf);
ealpha = DownDyadHi_PBS(ex,dqmf);


if oddx,
    beta = ebeta(1:(length(x)+1)/2);
    alpha = ealpha(1:(length(x)-1)/2);
else
    beta = ebeta(1:length(x)/2);
    alpha = ealpha(1:length(x)/2);
end



function y = extend(x, par1, par2)

if par1==1 & par2==1,
    y = [x x((length(x)-1):-1:2)];
elseif par1==1 & par2==2,
    y = [x x((length(x)-1):-1:1)];
elseif par1==2 & par2==1,
    y = [x x(length(x):-1:2)];
elseif par1==2 & par2==2,
    y = [x reverse(x)];
end



function d = DownDyadLo_PBS(x,qmf)

d = symm_aconv(qmf,x);
n = length(d);
d = d(1:2:(n-1));



function y = symm_aconv(sf,x)


n = length(x);
p = length(sf);
if p < n,
    xpadded = [x x(1:p)];
else
    z = zeros(1,p);
    for i=1:p,
        imod = 1 + rem(i-1,n);
        z(i) = x(imod);
    end
    xpadded = [x z];
end

fflip = reverse(sf);
ypadded = filter(fflip,1,xpadded);

if p < n,
    y = [ypadded((n+1):(n+p)) ypadded((p+1):(n))];
else
    for i=1:n,
        imod = 1 + rem(p+i-1,n);
        y(imod) = ypadded(p+i);
    end
end

shift = (p-1)/ 2 ;
shift = 1 + rem(shift-1, n);
y = [y((1+shift):n) y(1:(shift))] ;



function d = DownDyadHi_PBS(x,qmf)

d = symm_iconv( MirrorSymmFilt(qmf),lshift(x));
n = length(d);
d = d(1:2:(n-1));



function y = MirrorSymmFilt(x)

k = (length(x)-1)/2;
y = ( (-1).^((-k):k) ) .*x;



function y = symm_iconv(sf,x)

n = length(x);
p = length(sf);
if p <= n,
    xpadded = [x((n+1-p):n) x];
else
    z = zeros(1,p);
    for i=1:p,
        imod = 1 + rem(p*n -p + i-1,n);
        z(i) = x(imod);
    end
    xpadded = [z x];
end
ypadded = filter(sf,1,xpadded);
y = ypadded((p+1):(n+p));

shift = (p+1)/2;
shift = 1 + rem(shift-1, n);
y = [y(shift:n) y(1:(shift-1))];




function x = IWT_SBS(wc,L,qmf,dqmf)


wcoef = ShapeAsRow(wc);
[n,J] = dyadlength(wcoef);

dp = dyadpartition(n);

x = wcoef(1:dp(L+1));

for j=L:J-1,
    dyadj = (dp(j+1)+1):dp(j+2);
    x = UpDyad_SBS(x, wcoef(dyadj), qmf, dqmf);
end
x = ShapeLike(x,wc);


function x = UpDyad_SBS(beta,alpha,qmf,dqmf)

oddf = ~(qmf(1)==0 & qmf(length(qmf))~=0);
oddx = (length(beta) ~= length(alpha));

L = length(beta)+length(alpha);

if oddf,
    if oddx,
        ebeta = extend(beta,1,1);
        ealpha = extend(alpha,2,2);
    else
        ebeta = extend(beta,2,1);
        ealpha = extend(alpha,1,2);
    end
else
    if oddx,
        ebeta = extend(beta,1,2);
        ealpha = [alpha 0 -reverse(alpha)];
    else
        ebeta = extend(beta,2,2);
        ealpha = [alpha -reverse(alpha)];
    end
end

coarse = UpDyadLo_PBS(ebeta,dqmf);
fine = UpDyadHi_PBS(ealpha,qmf);
x = coarse + fine;
x = x(1:L);



function y = UpDyadLo_PBS(x,qmf)

y =  symm_iconv(qmf, UpSample(x,2) );



function y = UpDyadHi_PBS(x,qmf)

y = symm_aconv( MirrorSymmFilt(qmf), rshift( UpSample(x,2) ) );




function wc = FWT2_SBS(x,L,qmf,dqmf)


[m,J] = dyadlength(x(:,1));
[n,K] = dyadlength(x(1,:));
wc = x;
mc = m;
nc = n;

J = min([J,K]);

for jscal=J-1:-1:L,

    if rem(mc,2)==0,
        top = (mc/2+1):mc;
        bot = 1:(mc/2);
    else
        top = ((mc+1)/2+1):mc;
        bot = 1:((mc+1)/2);
    end
    if rem(nc,2)==0,
        right = (nc/2+1):nc;
        left = 1:(nc/2);
    else
        right = ((nc+1)/2+1):nc;
        left = 1:((nc+1)/2);
    end

    for ix=1:mc,
        row = wc(ix,1:nc);
        [beta,alpha] = DownDyad_SBS(row,qmf,dqmf);
        wc(ix,left) = beta;
        wc(ix,right) = alpha;
    end
    for iy=1:nc,
        column = wc(1:mc,iy)';
        [beta,alpha] = DownDyad_SBS(column,qmf,dqmf);
        wc(bot,iy) = beta';
        wc(top,iy) = alpha';
    end
    mc = bot(length(bot));
    nc = left(length(left));
end









function x = IWT2_SBS(wc,L,qmf,dqmf)


[m,J] = dyadlength(wc(:,1));
[n,K] = dyadlength(wc(1,:));

x = wc;

dpm = dyadpartition(m);

for jscal=L:J-1,
    bot = 1:dpm(jscal+1);
    top = (dpm(jscal+1)+1):dpm(jscal+2);
    all = [bot top];

    nc = length(all);

    for iy=1:nc,
        x(all,iy) =  UpDyad_SBS(x(bot,iy)', x(top,iy)', qmf, dqmf)';
    end
    for ix=1:nc,
        x(ix,all) = UpDyad_SBS(x(ix,bot), x(ix,top), qmf, dqmf);
    end
end



function wc = FWT2_PO(x,L,qmf)

[n,J] = quadlength(x);
wc = x;
nc = n;
for jscal=J-1:-1:L,
    top = (nc/2+1):nc; bot = 1:(nc/2);
    for ix=1:nc,
        row = wc(ix,1:nc);
        wc(ix,bot) = DownDyadLo(row,qmf);
        wc(ix,top) = DownDyadHi(row,qmf);
    end
    for iy=1:nc,
        row = wc(1:nc,iy)';
        wc(top,iy) = DownDyadHi(row,qmf)';
        wc(bot,iy) = DownDyadLo(row,qmf)';
    end
    nc = nc/2;
end



function x = IWT2_PO(wc,L,qmf)

[n,J] = quadlength(wc);
x = wc;
nc = 2^(L+1);
for jscal=L:J-1,
    top = (nc/2+1):nc; bot = 1:(nc/2); all = 1:nc;
    for iy=1:nc,
        x(all,iy) =  UpDyadLo(x(bot,iy)',qmf)'  ...
            + UpDyadHi(x(top,iy)',qmf)';
    end
    for ix=1:nc,
        x(ix,all) = UpDyadLo(x(ix,bot),qmf)  ...
            + UpDyadHi(x(ix,top),qmf);
    end
    nc = 2*nc;
end


function [n,J] = quadlength(x)

s = size(x);
n = s(1);
if s(2) ~= s(1),
    disp('Warning in quadlength: nr != nc')
end
k = 1 ; J = 0; while k < n , k=2*k; J = 1+J ; end ;
if k ~= n ,
    disp('Warning in quadlength: n != 2^J')
end



function wp = FWT_TI(x,L,qmf)


[n,J] = dyadlength(x);
D = J-L;
wp = zeros(n,D+1);
x = ShapeAsRow(x);
%
wp(:,1) = x';
for d=0:(D-1),
    for b=0:(2^d-1),
        s = wp(packet(d,b,n),1)';
        hsr = DownDyadHi(s,qmf);
        hsl = DownDyadHi(rshift(s),qmf);
        lsr = DownDyadLo(s,qmf);
        lsl = DownDyadLo(rshift(s),qmf);
        wp(packet(d+1,2*b  ,n),d+2) = hsr';
        wp(packet(d+1,2*b+1,n),d+2) = hsl';
        wp(packet(d+1,2*b  ,n),1  ) = lsr';
        wp(packet(d+1,2*b+1,n),1  ) = lsl';
    end
end




function tiwt = FWT2_TI(x,L,qmf)


[n,J] = quadlength(x);
D = J-L;

tiwt = zeros((3*D+1)*n, n);
lastx = (3*D*n+1):(3*D*n+n); lasty = 1:n;
tiwt(lastx,lasty) = x;
%
for d=0:(D-1),
    l = J-d-1; ns = 2^(J-d);
    for b1=0:(2^d-1), for b2=0:(2^d-1),
            s = tiwt(3*D*n+packet(d,b1,n), packet(d,b2,n));

            wc00 = FWT2_PO(s,l,qmf);
            wc01 = FWT2_PO(CircularShift(s,0,1),l,qmf);
            wc10 = FWT2_PO(CircularShift(s,1,0),l,qmf);
            wc11 = FWT2_PO(CircularShift(s,1,1),l,qmf);

            index10 = packet(d+1,2*b1,n); index20 = packet(d+1,2*b2,n);
            index11 = packet(d+1,2*b1+1,n); index21 = packet(d+1,2*b2+1,n);
         
            tiwt(3*d*n + index10 , index20) = wc00(1:(ns/2),(ns/2+1):ns);
            tiwt(3*d*n + index11,  index20) = wc01(1:(ns/2),(ns/2+1):ns);
            tiwt(3*d*n + index10 , index21) = wc10(1:(ns/2),(ns/2+1):ns);
            tiwt(3*d*n + index11 , index21) = wc11(1:(ns/2),(ns/2+1):ns);
     
            tiwt((3*d+1)*n + index10 , index20) = wc00((ns/2+1):ns,1:(ns/2));
            tiwt((3*d+1)*n + index11,  index20) = wc01((ns/2+1):ns,1:(ns/2));
            tiwt((3*d+1)*n + index10 , index21) = wc10((ns/2+1):ns,1:(ns/2));
            tiwt((3*d+1)*n + index11 , index21) = wc11((ns/2+1):ns,1:(ns/2));
   
            tiwt((3*d+2)*n + index10 , index20) = wc00((ns/2+1):ns,(ns/2+1):ns);
            tiwt((3*d+2)*n + index11,  index20) = wc01((ns/2+1):ns,(ns/2+1):ns);
            tiwt((3*d+2)*n + index10 , index21) = wc10((ns/2+1):ns,(ns/2+1):ns);
            tiwt((3*d+2)*n + index11 , index21) = wc11((ns/2+1):ns,(ns/2+1):ns);
         
            tiwt(3*D*n + index10 , index20) = wc00(1:(ns/2),1:(ns/2));
            tiwt(3*D*n + index11,  index20) = wc01(1:(ns/2),1:(ns/2));
            tiwt(3*D*n + index10 , index21) = wc10(1:(ns/2),1:(ns/2));
            tiwt(3*D*n + index11 , index21) = wc11(1:(ns/2),1:(ns/2));
        end, end
end


function p=packet(d,b,n)


npack = 2^d;
p =  ( (b * (n/npack) + 1) : ((b+1)*n/npack ) ) ;




function x = IWT_TI(pkt,qmf)

[n,D1] = size(pkt);
D = D1-1;
J = log2(n);
L = J-D;
%
wp = pkt;
%
sig = wp(:,1)';
for d= D-1:-1:0,
    for b=0:(2^d-1)
        hsr = wp(packet(d+1,2*b  ,n),d+2)';
        hsl = wp(packet(d+1,2*b+1,n),d+2)';
        lsr = sig(packet(d+1,2*b  ,n) );
        lsl = sig(packet(d+1,2*b+1,n) );
        loterm = (UpDyadLo(lsr,qmf) + lshift(UpDyadLo(lsl,qmf)))/2;
        hiterm = (UpDyadHi(hsr,qmf) + lshift(UpDyadHi(hsl,qmf)))/2;
        sig(packet(d,b,n)) = loterm+hiterm;
    end
end
x = sig;





function x = IWT2_TI(tiwt,L,qmf)

[D1,n] = size(tiwt);
J = log2(n);
D = J-L;
%
lastx = (3*D*n+1):(3*D*n+n); lasty = 1:n;
x = tiwt(lastx,lasty);

for d=(D-1):-1:0,
    l = J-d-1; ns = 2^(J-d);
    for b1=0:(2^d-1), for b2=0:(2^d-1),
            index10 = packet(d+1,2*b1,n); index20 = packet(d+1,2*b2,n);
            index11 = packet(d+1,2*b1+1,n); index21 = packet(d+1,2*b2+1,n);

            wc00 = [x(index10,index20) tiwt(3*d*n+index10,index20) ; ...
                tiwt((3*d+1)*n+index10,index20) tiwt((3*d+2)*n+index10,index20)];
            wc01 = [x(index11,index20) tiwt(3*d*n+index11,index20) ; ...
                tiwt((3*d+1)*n+index11,index20) tiwt((3*d+2)*n+index11,index20)];
            wc10 = [x(index10,index21) tiwt(3*d*n+index10,index21) ; ...
                tiwt((3*d+1)*n+index10,index21) tiwt((3*d+2)*n+index10,index21)];
            wc11 = [x(index11,index21) tiwt(3*d*n+index11,index21) ; ...
                tiwt((3*d+1)*n+index11,index21) tiwt((3*d+2)*n+index11,index21)];

            x(packet(d,b1,n), packet(d,b2,n)) = ( IWT2_PO(wc00,l,qmf) + ....
                CircularShift(IWT2_PO(wc01,l,qmf),0,-1) + ...
                CircularShift(IWT2_PO(wc10,l,qmf),-1,0) + ...
                CircularShift(IWT2_PO(wc11,l,qmf),-1,-1) ) / 4;
        end, end
end



function result = CircularShift(matrix, colshift, rowshift)


lastrow = size(matrix, 1);
lastcol = size(matrix, 2);

result = matrix;


if (colshift>0)
    result = [result(:,[lastcol-colshift+1:lastcol]) ...
        result(:,[1:lastcol-colshift])];
else
    colshift = -colshift;
    result = [result(:,[colshift+1:lastcol]) ...
        result(:,[1:colshift])];
end


if (rowshift>0)
    result = [result([lastrow-rowshift+1:lastrow],:) ; ...
        result([1:lastrow-rowshift],:)];
else
    rowshift = -rowshift;
    result = [result([rowshift+1:lastrow],:) ; ...
        result([1:rowshift],:)];
end

function x = reverse(x)

x = x(end:-1:1);


function StatWT = TI2Stat(TIWT)

StatWT = TIWT;
[n,D1] = size(StatWT);
D = D1-1;
J = log2(n);
L = J-D;
%
index = 1;

for d=1:D,
    nb = 2^d;
    nk = n/nb;

    index = [ (index+nb/2); index];
    index = index(:)';

    for b= 0:(nb-1),
        StatWT(d*n + (index(b+1):nb:n)) = TIWT(d*n + packet(d,b,n));
    end
end

for b= 0:(nb-1),
    StatWT((index(b+1):nb:n)) = TIWT(packet(d,b,n));
end



function TIWT = Stat2TI(StatWT)

TIWT = StatWT;
[n,D1] = size(StatWT);
D = D1-1;
index = 1;

for d=1:D,
    nb = 2^d;
    nk = n/nb;

    index = [ (index+nb/2); index];
    index = index(:)';

    for b= 0:(nb-1),
        TIWT(d*n + packet(d,b,n))  = StatWT(d*n + (index(b+1):nb:n));
    end
end

for b= 0:(nb-1),
    TIWT(packet(d,b,n)) = StatWT((index(b+1):nb:n));
end



function d = nb_dims(x)



if isempty(x)
    d = 0;
    return;
end

d = ndims(x);

if d==2 && (size(x,1)==1 || size(x,2)==1)
    d = 1;
end