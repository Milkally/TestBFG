load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 

begin 
print(">>>This is Draw_pop.ncl<<<")
;Input files
USER=asciiread("/cygdrive/C/Cygwin/username.txt",-1,"string")
DataPoolPath="/cygdrive/c/Users/"+USER+"/Documents/NCL_Example_190621/"
dataDataPop:=asciiread(DataPoolPath+"/data/"+"ssp2_2050_data.txt",-1,"integer") 

;分别提取需要的三组数据：data,lat,lon
DataPop:=dataDataPop(::3)              ;提取人口数据
latitude:=(dataDataPop(1::3))          ;提取纬度数据
longitude:=(dataDataPop(2::3))         ;提取经度数据
;Combine Datapop with lat and lon data
latitude@units = "degrees_north"        ;给经纬度变量设置单位
longitude@units = "degrees_east"
DataPop@lat2d=latitude                  ;将人口数据与经纬度数据匹配起来
DataPop@lon2d=longitude

;生成一个新的Workspace
wks_type = "pdf"
wks = gsn_open_wks(wks_type, DataPoolPath+"/result/check_Conc_SSP2Ref_2050.pdf") ;
;设置colormap底图
gsn_define_colormap(wks,"GMT_panoply") ; 设置色表 
	;Colormaps: https://www.ncl.ucar.edu/Document/Graphics/color_table_gallery.shtml

; 设置图片的各种参数
res = True 
res@cnFillOn = True ; 填色 
res@cnLinesOn = False ; 去掉等值线 
res@cnLineLabelsOn = False ; 去掉等值线的数字 
res@cnInfoLabelOn = False ; 去掉右下角说明 
res@gsnSpreadColors = True ; 6.1.0后默认即为True 

; 设置图片标题
res@tiMainString="SSP2 Pop, 0.125 ~S~o~N~ Resolution"
; 去掉右上角的文字 
res@gsnRightString = ""
;  设置渲染方式(要不要压缩图片以节省时间和空间）
; res@cnFillMode = "RasterFill" 

; 设置等值线起止、间隔 
; res@cnLevelSelectionMode = "ManualLevels" 
; res@cnMinLevelValF  = 0
; res@cnMaxLevelValF  = 120
; res@cnLevelSpacingF = 10
res@cnLevelSelectionMode = "ExplicitLevels" 
res@cnLevels = (/0, 100, 200, 500, 1000,2000,5000,10000,20000,100000/)

; 设置Label Bar 
res@lbBoxLinesOn = False ; Label bar上不标记黑线 


;画图
mapPop = gsn_csm_contour_map(wks,DataPop,res) 
draw(mapPop)

print(">>>Finish Plotting:Draw_pop.ncl<<<")
end
