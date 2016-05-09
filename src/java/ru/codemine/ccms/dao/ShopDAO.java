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

package ru.codemine.ccms.dao;

import java.util.List;
import ru.codemine.ccms.entity.Employee;
import ru.codemine.ccms.entity.Shop;

/**
 *
 * @author Alexander Savelev
 */
public interface ShopDAO 
{
    public void create(Shop shop);
    
    public void delete(Shop shop);
    public void deleteById(Integer id);
    
    public void update(Shop shop);
    
    public Shop getById(Integer id);
    public Shop getByName(String name);
    public List<Shop> getByAdmin(Employee admin);
    public List<Shop> getWithCounters();
    public List<Shop> getAllOpen();
    public List<Shop> getAll();

}
