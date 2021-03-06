      
--Verificar Data FechaIngreso Almacen	
With fETD(FechaETD1,FechaETD2,FechaETD3,FechaETD4,cia,imp)as(
Select Max(x.FechaETD1),Max(x.FechaETD2),Max(x.FechaETD3),Max(x.FechaETD4),x.cia_codcia,x.IdImportacion
From (
	Select a.cia_codcia, a.IdImportacion,
	    (Case when c.MaxSec>4 then(case when b.NroSec=(c.MaxSec-4+1)then b.FechaETD else null end)else(case when b.NroSec=1 then b.FechaETD else null end) end) FechaETD1,
	    (Case when c.MaxSec>4 then(case when b.NroSec=(c.MaxSec-4+2)then b.FechaETD else null end)else(case when b.NroSec=2 then b.FechaETD else null end) end) FechaETD2,
	    (Case when c.MaxSec>4 then(case when b.NroSec=(c.MaxSec-4+3)then b.FechaETD else null end)else(case when b.NroSec=3 then b.FechaETD else null end) end) FechaETD3,
	    (Case when c.MaxSec>4 then(case when b.NroSec=(c.MaxSec-4+4)then b.FechaETD else null end)else(case when b.NroSec=4 then b.FechaETD else null end) end) FechaETD4
	From CEX_Importacion A Left Join (Select cia_codcia, IdImportacion, max(NroSec) as MaxSec From CEX_ImportacionETD Group by cia_codcia, IdImportacion) C ON a.cia_codcia=c.cia_codcia and a.IdImportacion=c.IdImportacion
	                       Left Join CEX_ImportacionETD b on a.cia_codcia=b.cia_codcia and a.IdImportacion=b.IdImportacion) as X
Group by x.cia_codcia, x.IdImportacion
),
fETA(FechaETA1,FechaETA2,FechaETA3,FechaETA4,cia,imp)as(
Select Max(x.FechaETD1),Max(x.FechaETD2),Max(x.FechaETD3),Max(x.FechaETD4),x.cia_codcia,x.IdImportacion
From (
	Select a.cia_codcia, a.IdImportacion,
	    (Case when c.MaxSec>4 then(case when b.NroSec=(c.MaxSec-4+1)then b.fechaETA else null end)else(case when b.NroSec=1 then b.FechaETA else null end) end) FechaETD1,
	    (Case when c.MaxSec>4 then(case when b.NroSec=(c.MaxSec-4+2)then b.fechaETA else null end)else(case when b.NroSec=2 then b.FechaETA else null end) end) FechaETD2,
	    (Case when c.MaxSec>4 then(case when b.NroSec=(c.MaxSec-4+3)then b.fechaETA else null end)else(case when b.NroSec=3 then b.FechaETA else null end) end) FechaETD3,
	    (Case when c.MaxSec>4 then(case when b.NroSec=(c.MaxSec-4+4)then b.fechaETA else null end)else(case when b.NroSec=4 then b.FechaETA else null end) end) FechaETD4
	From CEX_Importacion A Left Join (Select cia_codcia, IdImportacion, max(NroSec) as MaxSec From CEX_ImportacionETA Group by cia_codcia, IdImportacion) C ON a.cia_codcia=c.cia_codcia and a.IdImportacion=c.IdImportacion
	                       Left Join CEX_ImportacionETA b on a.cia_codcia=b.cia_codcia and a.IdImportacion=b.IdImportacion) as X
Group by x.cia_codcia, x.IdImportacion
)
SELECT	  
	  ISNULL(YEAR(a.FechaETA),'')AS A?o,                      d.Seguimiento AS Estatus,                             ISNULL(a.CodAnt,' ')AS MF ,                           
      ISNULL(B.ProductoCEX,' ')AS Producto,                   ISNULL(C.ProveedorCEX,' ')AS Proveedor    ,           ISNULL(E.TipoCarga,' ')AS TipoCarga,        
	  ISNULL(ab.PresentacionCEX,' ')AS Presentacion,          ISNULL(a.PesoBBTM,0)AS PesoBBTM,                      ISNULL(t.Marca,' ')AS Marca,                     
	  ISNULL(CantidadTM,0)AS CantidadTM,                      ISNULL(J.Incoterm,' ')AS Incoterm ,                   ISNULL(a.PrecioUSDTM,0)AS PrecioUSDTM	 ,  
	  ISNULL(x.AlmacenDestino,' ')AS AlmacenDestino,          ISNULL(f.PuertoOrigen,' ') as PuertoOrigen,           ISNULL(v.PAI_NOMCOR,'')AS PaisOrigen,                 
	  ISNULL(g.PuertoDestino,'')AS PuertoLlegada,             ISNULL(a.NaveDestino ,'')AS NaveDestino,              ISNULL(a.BL,' ')AS BL,                      
	  ISNULL(l.Naviera,'')AS Naviera,                         ISNULL(a.IdClasificacionCEX,' ')AS Clase,             ISNULL(a.MesEmbProg,'')AS MesEmbProg,            
	  ISNULL(a.FechaContrato,' ')AS FechaContrato,            ISNULL(DATEPART(WEEK,a.FechaContrato),0) SemContrato, ISNULL(miETD.FechaETD,0)AS ETDInicial,
	  ISNULL(Datepart(Week,miETD.FechaETD),'')AS SemETDIni,  
	  fETD.FechaETD1 ,fETD.FechaETD2,fETD.FechaETD3,fETD.FechaETD4,           
	  ISNULL(maETD.FechaETD,'')AS UltimoETD,            
	  ISNULL(Datepart(Week,maETD.FechaETD),'')AS SemETDReal, 
	  ISNULL( DATEDIFF(WEEK,a.FechaContrato,maETD.FechaETD),0)AS LtETDReal,
	  (Case When maETD.FechaETD <= miETD.FechaETD Then 'VERDADERO' Else 'FALSO'End)AS CumpETD ,       
	  ISNULL(DATEDIFF(DAY,miETD.FechaETD,maETD.FechaETD),'')AS DifDiasETD,
	  ISNULL(a.FechaBL,' ')AS FechaBL , 
	  ISNULL(miETA.fechaETA,0)AS ETAInicial,          
	  fETA.FechaETA1 ,fETA.FechaETA2,fETA.FechaETA3,fETA.FechaETA4,    
	  ISNULL(maETA.fechaETA,'')AS UltimoETA,
	  ISNULL( DATEDIFF(WEEK,miETA.fechaETA,maETA.FechaETA),'')AS NVariacion, 
	  ISNULL(DATEPART(WEEK,maETA.fechaETA),'')AS SemETAReal,
	  ISNULL(DATEDIFF(DAY,a.FechaContrato,maETA.FechaETA),'')AS LtETAReal, 
	  (Case When DATEDIFF(DAY,maETA.FechaETA,miETA.fechaETA)<=3 Then 'VERDADERO' Else 'FALSO'End )AS CumpETASem , 
	  ISNULL(DATEDIFF(DAY,miETA.fechaETA,maETA.FechaETA),0)AS DifDiasETA,
      ISNULL(y.ConfirmaFecha,' ')AS TipoConfirmacion,
	  ISNULL(a.FechaIngAlmIni,'')AS FechaIngAlmEstIni,
	  ISNULL(e.TipoCarga,'')AS TipoCarga,                 
	  ISNULL(g.PuertoDestino+e.TipoCarga ,'')AS Concatenar,
	  ISNULL(ad.NroDiasETA,0)AS TIngreso ,
	  ISNULL(DATEADD(DAY,ad.NroDiasETA,maETA.fechaETA),'')AS FechaIngAlmEstFin,
	  ISNULL((DATEDIFF(DAY,a.FechaIngAlmIni,DATEADD(DAY,ad.NroDiasETA,maETA.fechaETA))),'')AS DifDiasIng,
	  ISNULL(DATEPART(WEEK,DATEADD(DAY,ad.NroDiasETA,maETA.fechaETA)),0) SemanaIng,  
	  ISNULL(a.FechaIngAlm,0)AS FechaFinIngAlm,
	  Space(5)AS DiasETDProm, Space(5)AS DiasETAProm,Space(5)AS DiasIngAlmProm,
	  ISNULL(DATEDIFF(DAY,a.FechaContrato,maETD.FechaETD),0)AS DiasETDReal,
	  ISNULL(DATEDIFF(DAY,maETD.FechaETD,maETA.fechaETA),0)AS DiasETAReal,
	  ISNULL(ad.NroDiasETA ,0) AS DiasIngAlmReal,
	  Space(5)AS LeadTimeEst,
	  ISNULL((DATEDIFF(DAY,a.FechaContrato,maETD.FechaETD)+DATEDIFF(DAY,maETD.FechaETD,maETA.fechaETA)+ad.NroDiasETA),'')AS LeadTimeReal,
	  Space(5)AS PVariacion ,
	  (Case When maETA.FechaETA=miETA.fechaETA Then 'VERDADERO'Else 'FALSO' End)AS CumpIngreso,
	  Space(5)AS CumpLeadTime , A.CodigoSG AS Codigo,
	  ISNULL(A.OCompraSG,'')AS CodigoOC,    	                          ISNULL(a.OCEstatus,'')AS EstatusOC,                  
	  Space(5)AS NCompra,Space(5)AS MDemora,Space(5)AS Coment ,               ISNULL(prd.prd_estado,'')AS EstProd
	From CEX_Importacion A
	Left Join Cex_ProductoCEX B on A.IdProductoCEX=B.IdProductoCEX
	Left Join Cex_ProveedorCEX C on A.IdProveedorCEX=C.IdProveedorCEX
	Left Join Cex_Seguimiento D on a.IdSeguimiento=d.IdSeguimiento
	Left Join Cex_TipoCarga E on a.IdTipoCarga=e.IdTipoCarga
	Left Join Cex_PuertoOrigen F on a.IdPuertoOrigen=f.IdPuertoOrigen
	Left Join Cex_PuertoDestino G on a.IdPuertoDestino=G.IdPuertoDestino
	Left Join CEX_Direccionamiento H on a.IdDireccionamiento = h.IdDireccionamiento
	left join CEX_CanalCEX I on a.IdCanalCEX=i.IdCanalCex
	left join CEX_Incoterm J on a.IdIncoterm=j.IdIncoterm
	left join CEX_EmisionBL K on a.IdEmisionBL=k.IdEmisionBL
	left join CEX_Naviera L on a.IdNaviera=l.IdNaviera
	left join CEX_Regimen M on a.IdRegimen=m.IdRegimen
	left join CEX_PresentacionCEX N on a.IdPresentacion=N.IdPresentacionCEX
	left join CEX_PlazoPago O on a.IdPlazoPago=o.IdPlazoPago
	left join CEX_DiasPlazo P on a.IdDiasPlazo=p.IdDiasPlazo
	left join CEX_EstadoPago Q on a.IdEstadoPago=q.IdEstadoPago
	Left Join CEX_TipoCarga02 R on a.IdTipoCarga02=r.IdTipoCarga02
	left join PRODUCTOS_PRD prd on a.prd_codepk=prd.prd_codepk
    Left Join CEX_ClasificacionMitsui S on b.IDClasificacionMitsui=s.IdClasificacionMitsui
	Left Join CEX_Marca T on a.IdMarca=t.IdMarca
	Left Join CEX_TerminoFletamiento U on a.IdFletamiento=U.IdFletamiento
	Left Join pais_pai V on a.pai_codpai=v.PAI_CODPAI
	Left Join CEX_TerminalMar W on a.IdTerminalMar=w.IdTerminalMar
	Left Join CEX_AlmacenDestino X on a.IdAlmacenDestino=x.IdAlmacenDestino
	left join CEX_ConfirmaFecha Y on a.IdConfirmaAlm = y.IdConfirmaFecha   
	left join CEX_PresentacionCEX ab on a.IdPresentacion = ab.IdPresentacionCEX
	left join CEX_Tabla_IngAlm_Estimado ad on a.IdPuertoDestino=ad.IdPuertoDestino and a.IdTipoCarga = ad.IdTipoCarga

	Left Join (Select cia_codcia, idimportacion, max(nrosec) as maxsec,min(NroSec)as minsec from CEX_ImportacionETD group by cia_codcia, idimportacion ) dETD on (a.cia_codcia=dETD.cia_codcia and a.IdImportacion=dETD.IdImportacion)
	Left Join CEX_ImportacionETD as maETD on a.cia_codcia=maETD.cia_codcia and a.IdImportacion=maETD.IdImportacion and dETD.maxsec=maETD.NroSec
	Left Join CEX_ImportacionETD as miETD on a.cia_codcia=miETD.cia_codcia and a.IdImportacion=miETD.IdImportacion and dETD.maxsec= miETD.NroSec
	Left Join fETD on a.cia_codcia=fETD.cia and a.IdImportacion=fETD.imp
	Left Join (Select cia_codcia, idimportacion, max(nrosec) as maxsec,min(NroSec)as minsec from CEX_ImportacionETA group by cia_codcia, idimportacion ) dETA on (a.cia_codcia=dETA.cia_codcia and a.IdImportacion=dETA.IdImportacion)
	Left Join CEX_ImportacionETA as miETA on a.cia_codcia=miETA.cia_codcia and a.IdImportacion=miETA.IdImportacion and dETA.minsec=miETA.NroSec
	Left Join CEX_ImportacionETA as maETA on a.cia_codcia=maETA.cia_codcia and a.IdImportacion=maETA.IdImportacion and dETA.maxsec=maETA.NroSec
	Left Join fETA on a.cia_codcia=fETA.cia and a.IdImportacion=fETA.imp

	


/*
Select Max(x.FechaETD1),Max(x.FechaETD2),Max(x.FechaETD3),Max(x.FechaETD4)
From (
	Select a.cia_codcia, a.IdImportacion,
	    (Case when c.MaxSec>4 then(case when b.NroSec=(c.MaxSec-4+1)then b.FechaETD else null end)else(case when b.NroSec=1 then b.FechaETD else null end) end) FechaETD1,
	    (Case when c.MaxSec>4 then(case when b.NroSec=(c.MaxSec-4+2)then b.FechaETD else null end)else(case when b.NroSec=2 then b.FechaETD else null end) end) FechaETD2,
	    (Case when c.MaxSec>4 then(case when b.NroSec=(c.MaxSec-4+3)then b.FechaETD else null end)else(case when b.NroSec=3 then b.FechaETD else null end) end) FechaETD3,
	    (Case when c.MaxSec>4 then(case when b.NroSec=(c.MaxSec-4+4)then b.FechaETD else null end)else(case when b.NroSec=4 then b.FechaETD else null end) end) FechaETD4
	From CEX_Importacion A Left Join (Select cia_codcia, IdImportacion, max(NroSec) as MaxSec From CEX_ImportacionETD Group by cia_codcia, IdImportacion) C ON a.cia_codcia=c.cia_codcia and a.IdImportacion=c.IdImportacion
	                       Left Join CEX_ImportacionETD b on a.cia_codcia=b.cia_codcia and a.IdImportacion=b.IdImportacion) as X
Group by x.cia_codcia, x.IdImportacion
*/

/*
	Left Join (Select e.IdTipoCarga,g.IdPuertoDestino ,(Case When e.TipoCarga Like 'Contenedor %' Then 4 When e.TipoCarga Like '%Granel%' Then 2 
	            When e.TipoCarga Like '%Breakbulk%' and g.PuertoDestino = '%Callao%'Then 10
			    When e.TipoCarga Like '%Breakbulk%' and g.PuertoDestino = '%Paita%'Then 7
			    Else 0 End)AS Num
			  FROM CEX_TipoCarga e, CEX_PuertoDestino g )AS TIng ON a.IdTipoCarga=TIng.IdTipoCarga and a.IdPuertoDestino=TIng.IdPuertoDestino  */