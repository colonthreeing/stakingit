--[[
self.config.joker_display_perishable = {
    n = G.UIT.ROOT,
    config = {
        minh = 0.5,
        maxh = 0.5,
        minw = 0.75,
        maxw = 0.75,
        r = 0.001,
        padding = 0.1,
        align = 'cm',
        colour = adjust_alpha(darken(G.C.BLACK, 0.2), 0.8),
        shadow = false,
        func = 'joker_display_perishable',
        ref_table = self
    },
    nodes = {
        {
            n = G.UIT.R,
            config = { align = "cm" },
            nodes = { { n = G.UIT.R, config = { align = "cm" }, nodes = { JokerDisplay.create_display_text_object({ ref_table = self.joker_display_values, ref_value = "perishable", colour = lighten(G.C.PERISHABLE, 0.35), scale = 0.35 }) } } }
        }

    }
}
]]

local create_display_text_object = function(config)
    local text_node = {}
    if config.ref_table then
        text_node = { n = G.UIT.T, config = { ref_table = config.ref_table, ref_value = config.ref_value, scale = config.scale or 0.4, colour = config.colour or G.C.UI.TEXT_LIGHT, font = ((SMODS or {}).Fonts or {})[config.font] or G.FONTS[tonumber(config.font)], retrigger_type = config.retrigger_type } }
    else
        text_node = { n = G.UIT.T, config = { text = config.text or "ERROR", scale = config.scale or 0.4, colour = config.colour or G.C.UI.TEXT_LIGHT, font = ((SMODS or {}).Fonts or {})[config.font] or G.FONTS[tonumber(config.font)], retrigger_type = config.retrigger_type } }
    end
    return text_node
end

function do_the_ui_thing(self)
    return {
        n = G.UIT.ROOT,
        config = {
            minh = 0.5,
            maxh = 0.5,
            minw = 0.5,
            maxw = 0.5,
            r = 1,
            padding = 0.1,
            align = 'cm',
            colour = adjust_alpha(darken(G.C.BLACK, 0.2), 0.8),
            shadow = false,
            func = 'staking_it_exclamation_mark',
            ref_table = self
        },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm" },
                nodes = { { n = G.UIT.R, config = { align = "cm" }, nodes = { create_display_text_object({ text = "!", colour = lighten(G.C.UI_MULT, 0.35), scale = 0.35 }) } } }
            }

        }
    }
end

function do_the_ui_config_thing(self)
    return {
        align = "tr",
        bond = 'Strong',
        parent = self,
        offset = { x = 0.0, y = 0 },
    }
end

G.FUNCS.staking_it_exclamation_mark = function(e)
    local card = e.config.ref_table
    if not (card.facing == 'back') and card.sticker_run ~= "gold" and card.config.center.set == "Joker" then
        e.states.visible = true
        e.parent.states.collide.can = true
    else
        e.states.visible = false
        e.parent.states.collide.can = false
    end
end

local old_update = Card.update
function Card:update(dt)
    old_update(self, dt)
    if self.ability then
        if not self.children.staking_it_exclamation_mark then
            self.config.staking_it_exclamation_mark = do_the_ui_thing(self)
            self.config.staking_it_exclamation_mark_config = do_the_ui_config_thing(self)

            self.children.staking_it_exclamation_mark = UIBox {
                definition = self.config.staking_it_exclamation_mark,
                config = self.config.staking_it_exclamation_mark_config,
            }

            self.children.staking_it_exclamation_mark.states.collide.can = true
            self.children.staking_it_exclamation_mark.name = "StakingIt"
        end
    end
end
