/*
 * Copyright (C) 2016 Alexander Savelev
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
package ru.codemine.ccms.router;

import java.util.List;
import java.util.Set;
import org.apache.log4j.Logger;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ru.codemine.ccms.entity.SalesMeta;
import ru.codemine.ccms.entity.Shop;
import ru.codemine.ccms.forms.SalesPlanForm;
import ru.codemine.ccms.service.OrganisationService;
import ru.codemine.ccms.service.SalesService;
import ru.codemine.ccms.service.ShopService;
import ru.codemine.ccms.utils.Utils;

/**
 *
 * @author Alexander Savelev
 */
@Controller
public class ActionRouter
{

    private static final Logger log = Logger.getLogger("ActionRouter");

    @Autowired private ShopService shopService;
    @Autowired private SalesService salesService;
    @Autowired private OrganisationService organisationService;
    @Autowired private Utils utils;

    @Secured("ROLE_OFFICE")
    @RequestMapping(value = "/actions/setPlan")
    public String getPlanSetupPage(
            @RequestParam(required = false) String dateMonth,
            @RequestParam(required = false) String dateYear,
            ModelMap model)
    {
        model.addAllAttributes(utils.prepareModel("Установить план продаж - ИнфоПортал", 
                "reports", "plan", 
                dateMonth, dateYear));
        
        model.addAttribute("organisationList", organisationService.getAll());
        model.addAttribute("salesMap", utils.getShopSalesMap(dateMonth, dateYear));

        return "actions/setPlan";
    }

    @Secured("ROLE_OFFICE")
    @RequestMapping(value = "/actions/setPlanAll", method = RequestMethod.POST)
    public String setPlanAll(
            @RequestParam String dateMonth,
            @RequestParam String dateYear,
            @RequestParam String value,
            ModelMap model)
    {
        String status;
        Double plan = 0.0;
        try
        {
            plan = Double.valueOf(value.replace(",", "."));

            DateTimeFormatter formatter = DateTimeFormat.forPattern("dd MMMM YYYY");
            LocalDate startDate = formatter.parseLocalDate("01 " + dateMonth + " " + dateYear);
            LocalDate endDate = formatter.parseLocalDate("01 " + dateMonth + " " + dateYear).dayOfMonth().withMaximumValue();
            List<Shop> shopList = shopService.getAllOpen();
            for(Shop shop: shopList)
            {
                SalesMeta sm = salesService.getByShopAndDate(shop, startDate, endDate);
                if(sm.getId() == null) salesService.update(sm);
            }
            
            
            if (salesService.updatePlanAll(plan, startDate, endDate))
            {
                status = "ok";
            }
            else
            {
                status = "error-server";
            }

            
        } catch (NumberFormatException e)
        {
            status = "error-all";
        }

        model.addAllAttributes(utils.prepareModel("Установить план продаж - ИнфоПортал", 
                "reports", "plan", 
                dateMonth, dateYear));
        
        model.addAttribute("organisationList", organisationService.getAll());
        model.addAttribute("salesMap", utils.getShopSalesMap(dateMonth, dateYear));
        model.addAttribute("status", status);

        return "actions/setPlan";
    }
    
    @Secured("ROLE_OFFICE")
    @RequestMapping(value = "/actions/setPlanByOrg", method = RequestMethod.POST)
    public String setPlanByOrg(
            @RequestParam String dateMonth,
            @RequestParam String dateYear,
            @RequestParam Integer orgId,
            @RequestParam String value,
            ModelMap model)
    {
        String status;
        Double plan = 0.0;
        try
        {
            plan = Double.valueOf(value.replace(",", "."));

            DateTimeFormatter formatter = DateTimeFormat.forPattern("dd MMMM YYYY");
            LocalDate startDate = formatter.parseLocalDate("01 " + dateMonth + " " + dateYear);
            LocalDate endDate = formatter.parseLocalDate("01 " + dateMonth + " " + dateYear).dayOfMonth().withMaximumValue();
            Set<Shop> shopList = organisationService.getById(orgId).getShops();
            for(Shop shop: shopList)
            {
                SalesMeta sm = salesService.getByShopAndDate(shop, startDate, endDate);
                sm.setPlan(plan);
                salesService.update(sm);
                
            }
            status = "ok";
        } 
        catch (NumberFormatException e)
        {
            status = "error-org";
        }

        model.addAllAttributes(utils.prepareModel("Установить план продаж - ИнфоПортал", 
                "reports", "plan", 
                dateMonth, dateYear));
        
        model.addAttribute("organisationList", organisationService.getAll());
        model.addAttribute("salesMap", utils.getShopSalesMap(dateMonth, dateYear));
        model.addAttribute("status", status);

        return "actions/setPlan";
        
    }
    
    @Secured("ROLE_OFFICE")
    @RequestMapping(value = "/actions/setPlanCustom", method = RequestMethod.POST)
    public @ResponseBody String setPlanCustom(
            @RequestParam String dateMonth,
            @RequestParam String dateYear,
            @RequestBody List<SalesPlanForm> salesPlanForms)
    {
        String resultStr;

        DateTimeFormatter formatter = DateTimeFormat.forPattern("dd MMMM YYYY");
        LocalDate selectedStartDate = formatter.parseLocalDate("01 " + dateMonth + " " + dateYear);
        LocalDate selectedEndDate = selectedStartDate.dayOfMonth().withMaximumValue();
        
        for(SalesPlanForm spf : salesPlanForms)
        {
            Shop shop = shopService.getByName(spf.getShopname());
            SalesMeta salesMeta = salesService.getByShopAndDate(shop, selectedStartDate, selectedEndDate);
            if(!salesMeta.getPlan().equals(spf.getPlan()))
            {
                salesMeta.setPlan(spf.getPlan());
                salesService.update(salesMeta);
            }
        }
        
        resultStr = "{\"result\": \"success\"}";
        
        return resultStr;
        
    }

}