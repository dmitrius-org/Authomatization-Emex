drop table if exists pFindByNumber
go
/* **********************************************************
pFindByNumber - 
********************************************************** */
create table pFindByNumber
(
 Spid                    numeric(18,0)  default @@spid
,ID                      numeric(18, 0) identity
,Available               nvarchar(128)  -- наличие детали на складе
,bitOldNum               bit            -- признак УСТАРЕВШИЙ НОМЕР
,PercentSupped           int            -- процент поставки
,PriceId                 int            -- идентификатор прайслиста
,Region                  nvarchar(256)  -- регион доставки детали
,Delivery                int            -- срок поставки
,Make                    nvarchar(10)   -- лого бренда детали
,DetailNum               nvarchar(64)   -- номер детали
,PriceLogo               nvarchar(64)   -- лого прайслиста
,Price                   money          -- цена детали, показаваемая на сайте
,PartNameRus             nvarchar(256)  -- русское название детали
,PartNameEng             nvarchar(256)  -- английское название детали
,WeightGr                money          -- вес детали в граммах
,MakeName                nvarchar(64)   -- название бренда
,Packing                 int            -- количество деталей в упаковке
,bitECO                  bit            
,bitWeightMeasured       bit            
,VolumeAdd               money          -- наценка объем (объемный вес)
,GuaranteedDay           nvarchar(64)   -- гарантированный срок поставки детали
)
go
grant all on pFindByNumber to public
go
create index ao1 on pFindByNumber(Spid, ID)
go
-- Описание таблицы
exec dbo.sys_setTableDescription @table = 'pFindByNumber', @desc = 'Результат поиска детали'

/* 
<Available>50</Available>
<bitOldNum>false</bitOldNum>
<PercentSupped>80</PercentSupped>
<PriceId>103</PriceId>
<Region/>
<Delivery>6</Delivery>
<Make>MC</Make>
<DetailNum>1428A293</DetailNum>
<PriceLogo>EMIR</PriceLogo>
<Price>0.66</Price>
<PartNameRus>ШАЙБА МЕТАЛЛИЧЕСКАЯ</PartNameRus>
<PartNameEng>WASHER, METAL</PartNameEng>
<WeightGr>6</WeightGr>
<MakeName>Mitsubishi</MakeName>
<Packing>1</Packing>
<bitECO>false</bitECO>
<bitWeightMeasured>true</bitWeightMeasured>
<VolumeAdd>0</VolumeAdd>
<GuaranteedDay>10</GuaranteedDay>
*/
